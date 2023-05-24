import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';

import '../../dominio/entidades/servico.dart';
import '../../dominio/entidades/tema.dart';

abstract class ManipularServicosI {
  Future<int> registarTema(Tema dado);
  Future<int> actualizarTema(Tema dado);
  Future<int> removerTema(int idDado);
  Future<List<Tema>> pegarListaTema();
  Future<Tema?> pegarTemaDeId(int id);
  
  Future<int> registarServico(Servico dado);
  Future<int> actualizarServico(Servico dado);
  Future<int> removerServico(int idDado);
  Future<List<Servico>> pegarListaServico();
  Future<Servico?> pegarServicoDeId(int id);
}
