import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/stock.dart';

import '../../contratos/provedores/provedor_stock_i.dart';

class ProvedorStock implements ProvedorStockI {
  late var  _dao;
  ProvedorStock() {
  }
  @override
  Future<int> inicializarStockProduto(int idProduto) async {
    return await _dao.inicializarStockProduto(idProduto);
  }

  @override
  Future<void> alterarQuantidadeStock(int idProduto, int quantidade) async {
    await _dao.alterarQuantidadeStock(idProduto, quantidade);
  }

  @override
  Future<Stock?> pegarStockDeId(int id) async {
    var res = await _dao.pegarStockDeId(id);
    if (res != null) {
      return Stock(
          id: res.id,
          estado: res.estado,
          idProduto: res.idProduto,
          quantidade: res.quantidade);
    }
    return null;
  }

  @override
  Future<Stock?> pegarStockDoProdutoDeId(int id) async {
    var res = await _dao.pegarStockDoProdutoDeId(id);
    if (res == null) {
      return null;
    }
    return Stock(
        id: res.id,
        estado: res.estado,
        idProduto: res.idProduto,
        quantidade: res.quantidade);
  }

  @override
  Future<void> removerStock(int id) async {
    await _dao.removerStockDeId(id);
  }

  @override
  Future<void> removerProdutoStock(int id) async {
    await _dao.removerStockProdutoDeId(id);
  }
}
