import 'package:flutter/material.dart';
import 'tela_principal.dart';

void main() {
  runApp(const MeuAplicativoVendas());
}

class MeuAplicativoVendas extends StatelessWidget {
  const MeuAplicativoVendas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Vendas com Índices',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TelaPrincipal(),
    );
  }
}
