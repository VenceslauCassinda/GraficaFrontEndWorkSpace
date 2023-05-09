import 'package:grafica_frontend/contratos/casos_uso/manipular_pagamento_i.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_comprovativo_i.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_pagamento_i.dart';
import 'package:grafica_frontend/dominio/entidades/forma_pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento_final.dart';
import 'package:grafica_frontend/fonte_dados/erros.dart';

class ManipularPagamento implements ManipularPagamentoI {
  final ProvedorPagamentoI _provedorPagamentoI;
  ProvedorComprovativoI? provedorComprovativoI;

  ManipularPagamento(this._provedorPagamentoI, {this.provedorComprovativoI});
  @override
  Future<List<Pagamento>> pegarLista() async {
    return await _provedorPagamentoI.pegarListaPagamento();
  }

  @override
  Future<void> registarListaPagamentos(
      List<Pagamento> lista, int idVenda) async {
    for (var cada in lista) {
      cada.idVenda = idVenda;
      await registarPagamento(cada);
    }
  }

  @override
  Future<int> registarPagamento(Pagamento pagamento) async {
    var i = await _provedorPagamentoI.registarPagamento(pagamento);
    if (pagamento.comprovativo != null) {
      pagamento.comprovativo!.idPagamento = i;
      await provedorComprovativoI!
          .registarComprovativo(pagamento.comprovativo!);
    }
    return i;
  }

  @override
  Future<int> adicionarFormaPagamento(FormaPagamento forma) async {
    if ((await existeFormaDeDescricao(forma.descricao!)) == true) {
      throw ErroFormaPagamentoExistente("JÁ EXISTE ESTA FORMA DE PAGAMENTO!");
    }
    return await _provedorPagamentoI.adicionarFormaPagamento(forma);
  }

  @override
  Future<List<FormaPagamento>> pegarListaFormasPagamento() async {
    return await _provedorPagamentoI.pegarListaFormasPagamento();
  }

  @override
  Future<bool> existeFormaDeDescricao(String descricao) async {
    return await _provedorPagamentoI.existeFormaDeDescricao(descricao);
  }

  @override
  Future<int> removerFormaDeId(int idForma) async {
    return _provedorPagamentoI.removerFormaDeId(idForma);
  }

  @override
  Future<int> registarPagamentoFinal(PagamentoFinal pagamentoFinal) async {
    return await _provedorPagamentoI.registarPagamentoFinal(pagamentoFinal);
  }
}
