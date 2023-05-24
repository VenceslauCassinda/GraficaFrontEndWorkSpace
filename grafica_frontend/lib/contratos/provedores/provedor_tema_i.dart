import '../../dominio/entidades/tema.dart';

abstract class ProvedorTemaI {
  Future<int> registarTema(Tema dado);
  Future<List<Tema>> pegarListaTema();
  Future<int> atualizarTema(Tema dado);
  Future<int> removerTemaDeId(int iddado);
}
