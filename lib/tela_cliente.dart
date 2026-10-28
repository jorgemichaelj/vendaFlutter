import 'package:flutter/material.dart';
import 'cliente.dart';
import 'dados_globais.dart';

class TelaCliente extends StatefulWidget {
  const TelaCliente({super.key});

  @override
  State<TelaCliente> createState() => _TelaClienteState();
}

class _TelaClienteState extends State<TelaCliente> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _apelidoCtrl = TextEditingController();
  final _turmaCtrl = TextEditingController();
  final _buscaCtrl = TextEditingController();

  List<Cliente> _clientesExibidos = [];
  Cliente? _clienteEmEdicao;
  bool _mostrarLista = false; // Controla se a listagem está visível

  // Sincroniza e filtra a lista local com base nos Dados Globais
  void _atualizarLista() {
    setState(() {
      if (_buscaCtrl.text.isEmpty) {
        _clientesExibidos = List.from(DadosGlobais.listaClientes);
      } else {
        _clientesExibidos = DadosGlobais.listaClientes
            .where((c) =>
                c.nome.toLowerCase().contains(_buscaCtrl.text.toLowerCase()) ||
                c.cpf.contains(_buscaCtrl.text))
            .toList();
      }
    });
  }

  // Limpa o formulário e reseta estados de edição
  void _limparFormulario() {
    setState(() {
      _clienteEmEdicao = null;
      _nomeCtrl.clear();
      _cpfCtrl.clear();
      _telCtrl.clear();
      _apelidoCtrl.clear();
      _turmaCtrl.clear();
    });
  }

  void _salvarCliente() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      if (_clienteEmEdicao == null) {
        // INSERIR: Adiciona um novo cliente no repositório global
        DadosGlobais.listaClientes.add(Cliente(
          nome: _nomeCtrl.text,
          cpf: _cpfCtrl.text,
          telefone: _telCtrl.text,
          apelido: _apelidoCtrl.text,
          turmaTurno: _turmaCtrl.text,
        ));
      } else {
        // ALTERAR: Atualiza os dados da referência existente
        _clienteEmEdicao!.nome = _nomeCtrl.text;
        _clienteEmEdicao!.cpf = _cpfCtrl.text;
        _clienteEmEdicao!.telefone = _telCtrl.text;
        _clienteEmEdicao!.apelido = _apelidoCtrl.text;
        _clienteEmEdicao!.turmaTurno = _turmaCtrl.text;
      }
      _limparFormulario();
      if (_mostrarLista) _atualizarLista();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operação realizada com sucesso!')),
    );
  }

  void _prepararEdicao(Cliente cliente) {
    setState(() {
      _clienteEmEdicao = cliente;
      _nomeCtrl.text = cliente.nome;
      _cpfCtrl.text = cliente.cpf;
      _telCtrl.text = cliente.telefone;
      _apelidoCtrl.text = cliente.apelido;
      _turmaCtrl.text = cliente.turmaTurno;
    });
  }

  void _excluirCliente(Cliente cliente) {
    setState(() {
      DadosGlobais.listaClientes.remove(cliente);
      _atualizarLista();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('CADASTRO DE CLIENTES', style: TextStyle(color: Colors.white)),
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
                        _clienteEmEdicao == null ? 'Inserir Novo Cliente' : 'Editando Cliente',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextFormField(controller: _nomeCtrl, decoration: const InputDecoration(labelText: 'Nome'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                      TextFormField(controller: _cpfCtrl, decoration: const InputDecoration(labelText: 'CPF'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                      TextFormField(controller: _telCtrl, decoration: const InputDecoration(labelText: 'Telefone'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                      TextFormField(controller: _apelidoCtrl, decoration: const InputDecoration(labelText: 'Apelido'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                      TextFormField(controller: _turmaCtrl, decoration: const InputDecoration(labelText: 'Turma / Turno'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                            onPressed: _salvarCliente,
                            child: Text(_clienteEmEdicao == null ? 'Salvar' : 'Confirmar'),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), foregroundColor: Colors.black),
                            onPressed: _limparFormulario,
                            child: Text(_clienteEmEdicao == null ? 'Limpar' : 'Cancelar'),
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
              child: Text(_mostrarLista ? 'Ocultar Cadastros' : 'Listar / Buscar Cadastros'),
            ),
            if (_mostrarLista) ...[
              const Divider(height: 24),
              TextField(
                controller: _buscaCtrl,
                decoration: const InputDecoration(labelText: 'Buscar por Nome ou CPF', suffixIcon: Icon(Icons.search)),
                onChanged: (val) => _atualizarLista(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _clientesExibidos.isEmpty
                    ? const Center(child: Text('Nenhum resultado encontrado.'))
                    : ListView.builder(
                        itemCount: _clientesExibidos.length,
                        itemBuilder: (ctx, idx) {
                          final cli = _clientesExibidos[idx];
                          // Procura o índice original na lista global para servir como ID explicativo
                          int idOriginal = DadosGlobais.listaClientes.indexOf(cli);
                          return ListTile(
                            title: Text('${cli.nome} (${cli.apelido})'),
                            subtitle: Text('Turma: ${cli.turmaTurno} | ID/Índice: $idOriginal'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _prepararEdicao(cli)),
                                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _excluirCliente(cli)),
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
