
import 'dart:convert';

class Tema{
  int? id;
  int? estado;
  String? tema;
  String? descricao;
  Tema(
      {this.id,
      this.estado,
      this.tema,
      this.descricao});

  Tema.fromJson(Map json) {
    tema = json['tema'];
    descricao = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tema'] = this.tema;
    data['descricao'] = this.descricao;
    data['id'] = this.id;
    return data;
  }
}