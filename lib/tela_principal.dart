import 'package:flutter/material.dart';
import 'tela_cliente.dart';
import 'tela_produto.dart';
import 'tela_vendas.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  // Função auxiliar para padronizar os botões do menu principal
  Widget _criarBotaoMenu(BuildContext context, String rotulo, IconData icone, Widget telaDestino) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => telaDestino));
        },
        icon: Icon(icone, color: Colors.white),
        label: Text(rotulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('MENU PRINCIPAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.point_of_sale, size: 100, color: Colors.black),
            const SizedBox(height: 40),
            _criarBotaoMenu(context, 'CLIENTES', Icons.people, const TelaCliente()),
            _criarBotaoMenu(context, 'PRODUTOS', Icons.shopping_bag, const TelaProduto()),
            _criarBotaoMenu(context, 'VENDAS', Icons.monetization_on, const TelaVendas()),
          ],
        ),
      ),
    );
  }
}
