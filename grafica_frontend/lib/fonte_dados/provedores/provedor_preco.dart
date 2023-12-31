import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/preco.dart';

import '../../contratos/provedores/provedor_preco_i.dart';

class ProvedorPreco implements ProvedorPrecoI {
  late var _dao;
  ProvedorPreco() {
  }
  @override
  Future<int> adicionarPrecoProduto(Preco preco) async {
    return await _dao.adicionarPrecoDeProduto(preco);
  }

  @override
  Future<void> removerPrecoProduto(double preco, int idProduto) async {
    await _dao.removerPrecoDoProduto(preco, idProduto);
  }

  @override
  Future<bool> existeProdutoComPreco(double preco, int idProduto) async {
    return (await _dao.existeProdutoComPreco(idProduto, preco)) != null;
  }

  @override
  Future<bool> atualizarPrecoProduto(Preco preco) async {
    return await _dao.atualizarPrecoProduto(preco);
  }

  @override
  Future<List<Preco>> pegarPrecoProdutoDeId(int id) async {
    return await _dao.pegarPrecoDeIdDeProduto(id);
  }
}
