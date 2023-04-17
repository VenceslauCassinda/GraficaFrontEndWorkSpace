import 'package:grafica_frontend/dominio/entidades/forma_pagamento.dart';

import 'pagamento_final.dart';

class Pagamento {
  FormaPagamento? formaPagamento;
  PagamentoFinal? pagamentoFinal;
  int? id;
  String? idParaVista;
  int? idFormaPagamento;
  int? estado;
  int? idVenda;
  double? valor;

  Pagamento(
      {this.id,
      this.formaPagamento,
      this.pagamentoFinal,
      this.idParaVista,
      this.idFormaPagamento,
      required this.estado,
      this.idVenda,
      required this.valor});
  
}
