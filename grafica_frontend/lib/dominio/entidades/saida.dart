import 'produto.dart';

class Saida {
  Produto? produto;
  int? id;
  int? estado;
  int? idProduto;
  int? idFuncionario;
  int? idVenda;
  int? idDivida;
  int? quantidade;
  DateTime? data;
  String? motivo;
  Saida(
      {this.id,
      this.produto,
      required this.estado,
      required this.idProduto,
      this.idFuncionario,
      this.idVenda,
      this.idDivida,
      required this.quantidade,
      required this.data,
      this.motivo});

  static String MOTIVO_VENDA = "Venda";
  static String MOTIVO_DIVIDA = "Dívida";
  static String MOTIVO_DESPERDICIO = "Desperdício";
  static String MOTIVO_AJUSTE_STOCK = "Ajuste de Stock";
  static String MOTIVO_INVENTARIO = "Inventário";

  Saida.fromJson(Map json) {
    idProduto = json['id_produto'];
    idFuncionario = json['id_funcionario'];
    motivo = json['motivo'];
    quantidade = json['quantidade'];
    var x = json['updated_at'];
    data =  x is String ? DateTime.parse(x): x;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_produto'] = this.idProduto;
    data['id_funcionario'] = this.idFuncionario;
    data['motivo'] = this.motivo;
    data['quantidade'] = this.quantidade;
    data['data'] = this.data;
    data['id'] = this.id;
    return data;
  }
  
}
