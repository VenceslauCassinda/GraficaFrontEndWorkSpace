import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento_final.dart';

import '../../dominio/entidades/comprovativo.dart';
import '../../dominio/entidades/forma_pagamento.dart';

abstract class ManipularPagamentoI {
  Future<int> registarPagamento(Pagamento pagamento);
  Future<int> registarPagamentoFinal(PagamentoFinal pagamentoFinal);
  Future<void> registarListaPagamentos(List<Pagamento> lista, int idVenda);
  Future<List<Pagamento>> pegarLista();
  Future<int> adicionarFormaPagamento(FormaPagamento forma);
  Future<bool> existeFormaDeDescricao(String descricao);
  Future<int> removerFormaDeId(int idForma);
  Future<Comprovativo?> pegarComprovativoDoPagamentoDeId(int id);
  Future<List<FormaPagamento>> pegarListaFormasPagamento();
  Future<List<FormaPagamento>> pegarListaFormasPagamentoCliente();
}
