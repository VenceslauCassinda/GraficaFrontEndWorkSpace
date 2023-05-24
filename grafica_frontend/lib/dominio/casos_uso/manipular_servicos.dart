import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_servicos_i.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_servico_i.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_tema_i.dart';
import 'package:grafica_frontend/dominio/entidades/tema.dart';
import 'package:grafica_frontend/dominio/entidades/servico.dart';

class ManipularServicos implements ManipularServicosI {
  final ProvedorServicoI _provedorServicoI;
  final ProvedorTemaI _provedorTemaI;

  ManipularServicos(this._provedorServicoI, this._provedorTemaI);
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
  
}