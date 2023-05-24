
import 'dart:convert';

class Servico{
  int? id;
  int? tipo;
  String? servico;
  String? descricao;
  Servico(
      {this.id,
      this.tipo,
      this.servico,
      this.descricao});

  Servico.fromJson(Map json) {
    servico = json['servico'];
    tipo = json['tipo'];
    descricao = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['servico'] = this.servico;
    data['descricao'] = this.descricao;
    data['tipo'] = this.tipo;
    data['id'] = this.id;
    return data;
  }
}