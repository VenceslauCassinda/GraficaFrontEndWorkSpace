import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_servicos_i.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_servico_i.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_tema_i.dart';
import 'package:grafica_frontend/dominio/entidades/tema.dart';
import 'package:grafica_frontend/dominio/entidades/servico.dart';
import 'package:grafica_frontend/dominio/entidades/tipo_detalhe.dart';
import '../../contratos/provedores/provedor_detalhe_item.dart';
import '../../contratos/provedores/provedor_evento_i.dart';
import '../entidades/evento.dart';

class ManipularServicos implements ManipularServicosI {
  final ProvedorServicoI _provedorServicoI;
  final ProvedorTemaI _provedorTemaI;
  final ProvedorEventoI _provedorEventoI;
  final ProvedorDetalheItemI _provedorDetalheItemI;

  ManipularServicos(this._provedorServicoI, this._provedorTemaI, this._provedorEventoI, this._provedorDetalheItemI);
  @override
  Future<int> actualizarServico(Servico dado) async{
    return await _provedorServicoI.atualizarServico(dado);
  }

  @override
  Future<int> actualizarTema(Tema dado) async{
    return await _provedorTemaI.atualizarTema(dado);
  }

  @override
  Future<List<Servico>> pegarListaServico() async{
    return await _provedorServicoI.pegarListaServico();
  }

  @override
  Future<List<Tema>> pegarListaTema() async{
    return await _provedorTemaI.pegarListaTema();
  }

  @override
  Future<Servico?> pegarServicoDeId(int id) async{
    return (await pegarListaServico()).firstWhereOrNull((element) => element.id == id);
  }

  @override
  Future<Tema?> pegarTemaDeId(int id) async{
    return (await pegarListaTema()).firstWhereOrNull((element) => element.id == id);
  }

  @override
  Future<int> registarServico(Servico dado) async{
    return await _provedorServicoI.registarServico(dado);
  }

  @override
  Future<int> registarTema(Tema dado) async{
    return await _provedorTemaI.registarTema(dado);
  }

  @override
  Future<int> removerServico(int idDado) async{
    return await _provedorServicoI.removerServicoDeId(idDado);
  }

  @override
  Future<int> removerTema(int idDado) async{
    return await _provedorTemaI.removerTemaDeId(idDado);
  }


  @override
  Future<int> actualizarEvento(Evento dado) async{
    return await _provedorEventoI.atualizarEvento(dado);
  }

  @override
  Future<List<Evento>> pegarListaEvento() async{
    return await _provedorEventoI.pegarListaEvento();
  }

  @override
  Future<Evento?> pegarEventoDeId(int id) async{
    return (await pegarListaEvento()).firstWhereOrNull((element) => element.id == id);
  }

  @override
  Future<int> removerEvento(int idDado) async{
    return await _provedorEventoI.removerEventoDeId(idDado);
  }
  
  @override
  Future<int> registarEvento(Evento dado)async{
    return await _provedorEventoI.registarEvento(dado);
  }

  @override
  Future<int> actualizarTipoDetalhe(TipoDetalhe dado) async{
    return await _provedorDetalheItemI.actualizarTipoDetalhe(dado);
  }

  @override
  Future<List<TipoDetalhe>> pegarListaTipoDetalhe() async{
    return await _provedorDetalheItemI.pegarListaTipoDetalhe();
  }

  @override
  Future<TipoDetalhe?> pegarTipoDetalheDeId(int id) async{
    return await _provedorDetalheItemI.pegarTipoDetalheDeId(id);
  }

  @override
  Future<int> registarTipoDetalhe(TipoDetalhe dado) async{
    return await _provedorDetalheItemI.registarTipoDetalhe(dado);
  }

  @override
  Future<int> removerTipoDetalhe(int idDado) async{
    return await _provedorDetalheItemI.removerTipoDetalhe(idDado);
  }
  
}