import 'package:grafica_frontend/dominio/entidades/produto.dart';

import 'receccao.dart';

class Entrada {
  Produto? produto;
  int? id;
  int? estado;
  int? idProduto;
  int? idFuncionario;
  int? idRececcao;
  int? quantidade;
  DateTime? data;
  String? motivo;
  Entrada(
      {this.id,
      this.produto,
      required this.estado,
      required this.idProduto,
      required this.idFuncionario,
      required this.idRececcao,
      required this.quantidade,
      required this.data,
      required this.motivo});

  static String MOTIVO_ABASTECIMENTO = "Abastecimento";
  static String MOTIVO_AJUSTE_STOCK = "Ajuste de Stock";

  Entrada.fromJson(Map json) {
    idProduto = json['id_produto'];
    idFuncionario = json['id_funcionario'];
    var x = json['updated_at'];
    data =  x is String ? DateTime.parse(x): x;
    motivo = json['motivo'];
    quantidade = json['quantidade'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_produto'] = this.idProduto;
    data['id_funcionario'] = this.idFuncionario;
    data['motivo'] = this.motivo;
    data['quantidade'] = this.quantidade;
    data['updated_at'] = this.data;
    data['id'] = this.id;
    return data;
  }
}
