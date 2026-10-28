import 'package:flutter/material.dart';
import 'dados_globais.dart';
import 'venda.dart';

class TelaVendas extends StatefulWidget {
  const TelaVendas({super.key});

  @override
  State<TelaVendas> createState() => _TelaVendasState();
}

class _TelaVendasState extends State<TelaVendas> {
  final _formKey = GlobalKey<FormState>();
  final _quantCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _vendedorCtrl = TextEditingController();

  int? _indiceClienteSelecionado;
  int? _indiceProdutoSelecionado;
  bool _mostrarHistorico = false;

  @override
  void initState() {
    super.initState();
    DateTime hoje = DateTime.now();
    _dataCtrl.text = "${hoje.day.toString().padLeft(2, '0')}/${hoje.month.toString().padLeft(2, '0')}/${hoje.year}";
  }

  void _limparCampos() {
    setState(() {
      _indiceClienteSelecionado = null;
      _indiceProdutoSelecionado = null;
      _quantCtrl.clear();
      _vendedorCtrl.clear();
    });
  }

  void _registrarVenda() {
    if (_indiceClienteSelecionado == null || _indiceProdutoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um Cliente e um Produto!')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    int? qtd = int.tryParse(_quantCtrl.text);
    if (qtd == null || qtd <= 0) return;

    // Resgata o valor unitário do produto usando o ÍNDICE capturado
    double valorUnitario = DadosGlobais.listaProdutos[_indiceProdutoSelecionado!].valor;
    double valorCalculado = valorUnitario * qtd;

    setState(() {
      // SALVAR RELACIONAMENTO: Grava apenas as chaves/índices numéricos das entidades
      DadosGlobais.listaVendas.add(Venda(
        indiceCliente: _indiceClienteSelecionado!,
        indiceProduto: _indiceProdutoSelecionado!,
        quantidade: qtd,
        data: _dataCtrl.text,
        vendedor: _vendedorCtrl.text,
        valorTotal: valorCalculado,
      ));
      _limparCampos();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Venda registrada com sucesso!')),
    );
  }

  void _mostrarComprovante(Venda v) {
    // BUSCAR POR ÍNDICE: Recupera os objetos em tempo de execução usando o índice salvo
    final cliente = DadosGlobais.listaClientes[v.indiceCliente];
    final produto = DadosGlobais.listaProdutos[v.indiceProduto];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Comprovante de Venda', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${cliente.nome} (${cliente.apelido})'),
            Text('CPF: ${cliente.cpf} | Turma: ${cliente.turmaTurno}'),
            const Divider(),
            Text('Produto: ${produto.nome}'),
            Text('Qtd: ${v.quantidade} ${produto.unidade} | Unitário: R\$ ${produto.valor.toStringAsFixed(2)}'),
            const Divider(),
            Text('Vendedor: ${v.vendedor}'),
            Text('Data: ${v.data}'),
            const SizedBox(height: 10),
            Text('TOTAL: R\$ ${v.valorTotal.toStringAsFixed(2)}', 
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fechar'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('REGISTRO DE VENDAS', style: TextStyle(color: Colors.white)),
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
                      DropdownButtonFormField<int>(
                        value: _indiceClienteSelecionado,
                        hint: const Text('Selecione o Cliente'),
                        // O value mapeia a POSIÇÃO (índice) do elemento na lista global
                        items: List.generate(DadosGlobais.listaClientes.length, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(DadosGlobais.listaClientes[index].nome),
                          );
                        }),
                        onChanged: (val) => setState(() => _indiceClienteSelecionado = val),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _indiceProdutoSelecionado,
                        hint: const Text('Selecione o Produto'),
                        items: List.generate(DadosGlobais.listaProdutos.length, (index) {
                          final p = DadosGlobais.listaProdutos[index];
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text('${p.nome} (R\$ ${p.valor.toStringAsFixed(2)})'),
                          );
                        }),
                        onChanged: (val) => setState(() => _indiceProdutoSelecionado = val),
                      ),
                      TextFormField(controller: _quantCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantidade')),
                      TextFormField(controller: _vendedorCtrl, decoration: const InputDecoration(labelText: 'Nome do Vendedor')),
                      TextFormField(controller: _dataCtrl, decoration: const InputDecoration(labelText: 'Data')),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                            onPressed: _registrarVenda,
                            child: const Text('Registrar Venda'),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), foregroundColor: Colors.black),
                            onPressed: _limparCampos,
                            child: const Text('Limpar'),
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
              onPressed: () => setState(() => _mostrarHistorico = !_mostrarHistorico),
              child: Text(_mostrarHistorico ? 'Ocultar Histórico' : 'Ver Histórico de Vendas'),
            ),
            if (_mostrarHistorico)
              Expanded(
                child: DadosGlobais.listaVendas.isEmpty
                    ? const Center(child: Text('Nenhuma venda registrada.'))
                    : ListView.builder(
                        itemCount: DadosGlobais.listaVendas.length,
                        itemBuilder: (ctx, idx) {
                          final v = DadosGlobais.listaVendas[idx];
                          // Busca os nomes associados dinamicamente para mostrar na listagem simples
                          final nomeCli = DadosGlobais.listaClientes[v.indiceCliente].nome;
                          final nomeProd = DadosGlobais.listaProdutos[v.indiceProduto].nome;
                          return Card(
                            child: ListTile(
                              title: Text('Comprador: $nomeCli'),
                              subtitle: Text('$nomeProd | Qtd: ${v.quantidade} | Em: ${v.data}'),
                              trailing: Text('R\$ ${v.valorTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              onTap: () => _mostrarComprovante(v),
                            ),
                          );
                        },
                      ),
              )
            else
              const Expanded(child: SizedBox())
          ],
        ),
      ),
    );
  }
}
