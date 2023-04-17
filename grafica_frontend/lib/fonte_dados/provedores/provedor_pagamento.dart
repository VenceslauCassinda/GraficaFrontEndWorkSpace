import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_pagamento_i.dart';
import 'package:grafica_frontend/dominio/entidades/forma_pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento_final.dart';

import '../../dominio/entidades/pagamento.dart';

class ProvedorPagamento implements ProvedorPagamentoI {
  late var _dao;
  late var _formaPagamentoDao;
  ProvedorPagamento() {
  }
  @override
  Future<List<Pagamento>> pegarLista() async {
    var res = await _dao.todos();

    return res
        .map((e) => Pagamento(
            idFormaPagamento: e.idFormaPagamento,
            estado: e.estado,
            idVenda: e.idVenda,
            valor: e.valor))
        .toList();
  }

  @override
  Future<int> registarPagamento(Pagamento pagamento) async {
    return await _dao.adicionarPagamento(pagamento);
  }

  @override
  Future<int> adicionarFormaPagamento(FormaPagamento forma) async {
    return await _formaPagamentoDao.adicionarFormaPagamento(forma);
  }

  @override
  Future<List<FormaPagamento>> pegarListaFormasPagamento() async {
    var res = await _formaPagamentoDao.todos();
    return res
        .map((e) => FormaPagamento(
            id: e.id, estado: e.estado, tipo: e.tipo, descricao: e.descricao))
        .toList();
  }

  @override
  Future<bool> existeFormaDeDescricao(String descricao) async {
    var res = await _formaPagamentoDao.existeFormaDeDescricao(descricao);
    return res != null;
  }

  @override
  Future<int> removerFormaDeId(int idForma) async {
    return await _formaPagamentoDao.removerFormaPagamento(idForma);
  }

  @override
  Future<int> registarPagamentoFinal(PagamentoFinal pagamentoFinal) async {
    return await _dao.adicionarPagamentoFinal(pagamentoFinal);
  }
}
