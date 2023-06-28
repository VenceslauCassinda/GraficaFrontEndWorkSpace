
import '../../dominio/entidades/tipo_detalhe.dart';
import '../../dominio/entidades/evento.dart';
import '../../dominio/entidades/servico.dart';
import '../../dominio/entidades/tema.dart';

abstract class ManipularServicosI {
  Future<int> registarTema(Tema dado);
  Future<int> actualizarTema(Tema dado);
  Future<int> removerTema(int idDado);
  Future<List<Tema>> pegarListaTema();
  Future<Tema?> pegarTemaDeId(int id);
  
  Future<int> registarEvento(Evento dado);
  Future<int> actualizarEvento(Evento dado);
  Future<int> removerEvento(int idDado);
  Future<List<Evento>> pegarListaEvento();
  Future<Evento?> pegarEventoDeId(int id);
  
  Future<int> registarServico(Servico dado);
  Future<int> actualizarServico(Servico dado);
  Future<int> removerServico(int idDado);
  Future<List<Servico>> pegarListaServico();
  Future<Servico?> pegarServicoDeId(int id);
  
  Future<int> registarTipoDetalhe(TipoDetalhe dado);
  Future<int> actualizarTipoDetalhe(TipoDetalhe dado);
  Future<int> removerTipoDetalhe(int idDado);
  Future<List<TipoDetalhe>> pegarListaTipoDetalhe();
  Future<TipoDetalhe?> pegarTipoDetalheDeId(int id);
}
