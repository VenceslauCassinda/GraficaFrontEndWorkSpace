import 'package:grafica_frontend/dominio/entidades/entrada.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';

abstract class ManipularEntradaI {
  Future<int> registarEntrada(Entrada entrada);
  Future<int> actualizarEntrada(Entrada entrada);
  Future<List<Entrada>> pegarLista();
  Future<List<Entrada>> pegarListaEntradasFuncionario(Funcionario funcionario);
  Future<List<Entrada>> pegarListaDoProduto(Produto produto);
  Future<Entrada?> pegarEntradaDeProdutoDeId(int id);
  Future removerTudo();
  Future removerAntes(DateTime data);
}
