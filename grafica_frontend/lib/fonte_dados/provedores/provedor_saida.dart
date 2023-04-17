import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/saida.dart';

import '../../contratos/provedores/provedor_saida_i.dart';

class ProvedorSaida implements ProvedorSaidaI {
  late var  _dao;
  ProvedorSaida() {
  }
  @override
  Future<List<Saida>> pegarLista() async {
    return await _dao.todas();
  }

  @override
  Future<int> registarSaida(Saida saida) async {
    return await _dao.adicionarSaida(saida);
  }

  @override
  Future<List<Saida>> pegarListaDoProduto(int idProduto) async {
    return await _dao.todasComProdutoDeId(idProduto);
  }

  @override
  Future<Saida?> pegarSaidaDeProdutoDeId(int id) async {
    return await _dao.pegarSaidaDeProdutoDeId(id);
  }

  @override
  Future<int> actualizarSaida(Saida saida) async {
    await _dao.actualizar(saida);
    return 1;
  }

  @override
  Future removerAntes(DateTime data) async {
    await _dao.removerAntes(data);
  }

  @override
  Future removerTudo() async {
    await _dao.removerTudo();
  }

  @override
  Future<Saida?> pegarSaidaDeProdutoDeIdEmotivo(int id, String motivo) async {
    return await _dao.pegarSaidaDeProdutoDeIdEmotivo(id, motivo);
  }
  
  @override
  Future<Saida?> pegarSaidaDeId(int id) {
    // TODO: implement pegarSaidaDeId
    throw UnimplementedError();
  }
  
  @override
  Future remover(int id) {
    // TODO: implement remover
    throw UnimplementedError();
  }
  
  @override
  Future<List<Saida>> pegarListaSaidasFuncionario(int id) {
    // TODO: implement pegarListaSaidasFuncionario
    throw UnimplementedError();
  }
}
