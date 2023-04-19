import 'produto.dart';

class ItemVenda {
  Produto? produto;
  int? id;
  int? estado;
  int? idProduto;
  int? idVenda;
  String? idVista;
  int? quantidade;
  double? total;
  int? desconto;
  ItemVenda(
      {this.id,
      required this.estado,
      required this.idProduto,
      this.idVenda,
      this.idVista,
      required this.quantidade,
      this.total,
      this.produto,
      required this.desconto});

  ItemVenda.fromJson(Map json) {
    idProduto = json['id_produto'];
    idVenda = json['id_pedido'];
    total = json['total'];
    desconto = json['desconto'];
    estado = json['estado'];
    quantidade = json['quantidade'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_produto'] = this.idProduto;
    data['id_pedido'] = this.idVenda;
    data['total'] = this.total;
    data['desconto'] = this.desconto;
    data['estado'] = this.estado;
    data['quantidade'] = this.quantidade;
    data['id'] = this.id;
    return data;
  }
}
