import 'package:grafica_frontend/dominio/entidades/entrada.dart';

abstract class ProvedorEntradaI {
  Future<int> registarEntrada(Entrada entrada);
  Future<List<Entrada>> pegarLista();
  Future<List<Entrada>> pegarListaDoProduto(int idProduto);
  Future<List<Entrada>> pegarListaEntradasFuncionario(int idFuncionario);
  Future<Entrada?> pegarEntradaDeProdutoDeId(int id);
  Future<Entrada?> pegarEntradaDeId(int id);
  Future<int> actualizarEntrada(Entrada entrada);
  Future removerTudo();
  Future removerAntes(DateTime data);
  Future remover(int id);
}
