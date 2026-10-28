// Modelo de dados para a Venda referenciando índices (Banco de Dados)
class Venda {
  int indiceCliente; // Guarda apenas a posição do cliente na lista global
  int indiceProduto; // Guarda apenas a posição do produto na lista global
  int quantidade;
  String data;
  String vendedor;
  double valorTotal;

  Venda({
    required this.indiceCliente,
    required this.indiceProduto,
    required this.quantidade,
    required this.data,
    required this.vendedor,
    required this.valorTotal,
  });
}
