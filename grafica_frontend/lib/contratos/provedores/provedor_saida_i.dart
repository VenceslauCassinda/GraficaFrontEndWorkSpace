import 'package:grafica_frontend/dominio/entidades/entrada.dart';
import 'package:grafica_frontend/dominio/entidades/saida.dart';

abstract class ProvedorSaidaI {
  Future<int> registarSaida(Saida saida);
  Future<int> actualizarSaida(Saida saida);
  Future<List<Saida>> pegarLista();
  Future<List<Saida>> pegarListaDoProduto(int idProduto);
  Future<Saida?> pegarSaidaDeProdutoDeId(int id);
  Future<Saida?> pegarSaidaDeId(int id);
  Future<List<Saida>> pegarListaSaidasFuncionario(int id);
  Future<Saida?> pegarSaidaDeProdutoDeIdEmotivo(int id, String motivo);
  Future removerTudo();
  Future removerAntes(DateTime data);
  Future remover(int id);
}
