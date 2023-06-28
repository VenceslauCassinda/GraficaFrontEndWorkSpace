
import '../../dominio/entidades/evento.dart';

abstract class ProvedorEventoI {
  Future<int> registarEvento(Evento dado);
  Future<List<Evento>> pegarListaEvento();
  Future<int> atualizarEvento(Evento dado);
  Future<int> removerEventoDeId(int iddado);
}
