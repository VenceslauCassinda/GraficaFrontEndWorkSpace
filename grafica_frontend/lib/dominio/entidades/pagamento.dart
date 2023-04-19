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
  
  Pagamento.fromJson(Map json) {
    idFormaPagamento = json['id_forma_pagamento'];
    idVenda = json['id_venda'];
    estado = json['estado'];
    valor = json['valor'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_forma_pagamento'] = this.idFormaPagamento;
    data['id_venda'] = this.idVenda;
    data['estado'] = this.estado;
    data['valor'] = this.valor;
    data['id'] = this.id;
    return data;
  }
}
