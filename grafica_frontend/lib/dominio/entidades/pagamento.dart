import 'package:grafica_frontend/dominio/entidades/comprovativo.dart';
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
  Comprovativo? comprovativo;
  static int A_VISTA = 0;
  static int A_PRAZO = 1;

  Pagamento(
      {this.id,
      this.formaPagamento,
      this.pagamentoFinal,
      this.idParaVista,
      this.idFormaPagamento,
      this.comprovativo,
      required this.estado,
      this.idVenda,
      required this.valor});
  
  Pagamento.fromJson(Map json) {
    idFormaPagamento = json['id_forma_pagamento'];
    idVenda = json['id_pedido'];
    estado = json['estado'];
    valor = json['valor'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_forma_pagamento'] = this.idFormaPagamento;
    data['id_pedido'] = this.idVenda;
    data['estado'] = this.estado;
    data['valor'] = this.valor;
    data['id'] = this.id;
    return data;
  }

  static String paraTexto(int nivel) {
    if (nivel == A_VISTA) {
      return "À Vista";
    }
    return "À Prazo";
  }

  static int paraInteiro(String nivel) {
    if (nivel == "À Vista") {
      return A_VISTA;
    }
    return A_PRAZO;
  }
}
