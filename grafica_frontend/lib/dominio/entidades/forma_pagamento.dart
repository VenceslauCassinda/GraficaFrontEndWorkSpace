
import 'dart:convert';

class FormaPagamento{
  int? id;
  int? estado;
  int? tipo;
  String? forma;
  String? descricao;
  FormaPagamento(
      {this.id,
      this.estado,
      this.tipo,
      this.forma,
      this.descricao});

  FormaPagamento.fromJson(Map json) {
    forma = json['forma'];
    tipo = json['tipo'];
    descricao = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forma'] = forma;
    data['tipo'] = tipo;
    data['descricao'] = descricao;
    data['id'] = id;
    return data;
  }
}