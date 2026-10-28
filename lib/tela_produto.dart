import 'package:flutter/material.dart';
import 'produto.dart';
import 'dados_globais.dart';

class TelaProduto extends StatefulWidget {
  const TelaProduto({super.key});

  @override
  State<TelaProduto> createState() => _TelaProdutoState();
}

class _TelaProdutoState extends State<TelaProduto> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _unidCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();
  final _buscaCtrl = TextEditingController();

  List<Produto> _produtosExibidos = [];
  Produto? _produtoEmEdicao;
  bool _mostrarLista = false;

  void _atualizarLista() {
    setState(() {
      if (_buscaCtrl.text.isEmpty) {
        _produtosExibidos = List.from(DadosGlobais.listaProdutos);
      } else {
        _produtosExibidos = DadosGlobais.listaProdutos
            .where((p) => p.nome.toLowerCase().contains(_buscaCtrl.text.toLowerCase()))
            .toList();
      }
    });
  }

  void _limparFormulario() {
    setState(() {
      _produtoEmEdicao = null;
      _nomeCtrl.clear();
      _unidCtrl.clear();
      _valorCtrl.clear();
    });
  }

  void _salvarProduto() {
    if (!_formKey.currentState!.validate()) return;

    double? vlrParsed = double.tryParse(_valorCtrl.text.replaceAll(',', '.'));
    if (vlrParsed == null) return;

    setState(() {
      if (_produtoEmEdicao == null) {
        DadosGlobais.listaProdutos.add(Produto(
          nome: _nomeCtrl.text,
          unidade: _unidCtrl.text,
          valor: vlrParsed,
        ));
      } else {
        _produtoEmEdicao!.nome = _nomeCtrl.text;
        _produtoEmEdicao!.unidade = _unidCtrl.text;
        _produtoEmEdicao!.valor = vlrParsed;
      }
      _limparFormulario();
      if (_mostrarLista) _atualizarLista();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto processado com sucesso!')),
    );
  }

  void _prepararEdicao(Produto produto) {
    setState(() {
      _produtoEmEdicao = produto;
      _nomeCtrl.text = produto.nome;
      _unidCtrl.text = produto.unidade;
      _valorCtrl.text = produto.valor.toString();
    });
  }

  void _excluirProduto(Produto produto) {
    setState(() {
      DadosGlobais.listaProdutos.remove(produto);
      _atualizarLista();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('CADASTRO DE PRODUTOS', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        _produtoEmEdicao == null ? 'Inserir Novo Produto' : 'Editando Produto',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextFormField(controller: _nomeCtrl, decoration: const InputDecoration(labelText: 'Nome do Produto'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                      TextFormField(controller: _unidCtrl, decoration: const InputDecoration(labelText: 'Unidade (Ex: UN, KG, LT)'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                      TextFormField(controller: _valorCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Valor Unitário'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                            onPressed: _salvarProduto,
                            child: Text(_produtoEmEdicao == null ? 'Salvar' : 'Confirmar'),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), foregroundColor: Colors.black),
                            onPressed: _limparFormulario,
                            child: Text(_produtoEmEdicao == null ? 'Limpar' : 'Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _mostrarLista = !_mostrarLista;
                  if (_mostrarLista) _atualizarLista();
                });
              },
              child: Text(_mostrarLista ? 'Ocultar Listagem' : 'Listar / Buscar Produtos'),
            ),
            if (_mostrarLista) ...[
              const Divider(height: 24),
              TextField(
                controller: _buscaCtrl,
                decoration: const InputDecoration(labelText: 'Buscar Produto por Nome', suffixIcon: Icon(Icons.search)),
                onChanged: (val) => _atualizarLista(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _produtosExibidos.isEmpty
                    ? const Center(child: Text('Nenhum produto cadastrado.'))
                    : ListView.builder(
                        itemCount: _produtosExibidos.length,
                        itemBuilder: (ctx, idx) {
                          final prod = _produtosExibidos[idx];
                          int idOriginal = DadosGlobais.listaProdutos.indexOf(prod);
                          return ListTile(
                            title: Text(prod.nome),
                            subtitle: Text('Preço: R\$ ${prod.valor.toStringAsFixed(2)} | ID/Índice: $idOriginal'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _prepararEdicao(prod)),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _excluirProduto(prod)),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ] else
              const Expanded(child: SizedBox())
          ],
        ),
      ),
    );
  }
}
