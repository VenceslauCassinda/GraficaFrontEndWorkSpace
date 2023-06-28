
import 'dart:convert';

class Evento{
  int? id;
  int? estado;
  String? evento;
  String? descricao;
  Evento(
      {this.id,
      this.estado,
      this.evento,
      this.descricao});

  Evento.fromJson(Map json) {
    evento = json['evento'];
    descricao = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['evento'] = this.evento;
    data['descricao'] = this.descricao;
    data['id'] = this.id;
    return data;
  }
}