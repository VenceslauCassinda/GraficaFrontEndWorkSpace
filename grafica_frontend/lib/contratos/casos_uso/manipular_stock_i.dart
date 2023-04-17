import 'package:grafica_frontend/dominio/entidades/stock.dart';

abstract class ManipularStockI {
  Future<int> inicializarStockProduto(int idProduto);
  Future<void> aumentarQuantidadeStock(int idProduto, int quantidade);
  Future<void> diminuirQuantidadeStock(int idProduto, int quantidade);
  Future<Stock?> pegarStockDeId(int id);
  Future<Stock?> pegarStockDoProdutoDeId(int id);
  Future<void> removerStock(int id);
  Future<void> removerProdutoStock(int id);
}
