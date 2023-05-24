
import '../../dominio/entidades/servico.dart';

abstract class ProvedorServicoI {
  Future<int> registarServico(Servico dado);
  Future<List<Servico>> pegarListaServico();
  Future<int> atualizarServico(Servico dado);
  Future<int> removerServicoDeId(int iddado);
}
