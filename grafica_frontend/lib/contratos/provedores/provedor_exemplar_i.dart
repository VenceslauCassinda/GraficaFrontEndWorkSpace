import '../../dominio/entidades/Exemplar.dart';
import '../../dominio/entidades/comprovativo.dart';

abstract class ProvedorExemplarI {
  Future<int> registarExemplar(Exemplar exemplar);
  Future<List<Exemplar>> pegarListaExemplar();
  Future<int> atualizarExemplar(Exemplar dado);
  Future<int> removerExemplarDeId(int idDado);
}
