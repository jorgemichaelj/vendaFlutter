import 'cliente.dart';
import 'produto.dart';
import 'venda.dart';

// Repositório centralizado em memória para simular o banco de dados
class DadosGlobais {
  static List<Cliente> listaClientes = [];
  static List<Produto> listaProdutos = [];
  static List<Venda> listaVendas = [];
}
