import '../../dominio/entidades/comprovativo.dart';

abstract class ProvedorComprovativoI {
  Future<int> registarComprovativo(Comprovativo comprovativo);
  Future<List<Comprovativo>> pegarListaComprovativo();
  Future<int> atualizarComprovativo(Comprovativo forma);
  Future<int> removerComprovativoDeId(int idForma);
}
