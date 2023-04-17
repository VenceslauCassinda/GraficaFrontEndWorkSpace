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
}
