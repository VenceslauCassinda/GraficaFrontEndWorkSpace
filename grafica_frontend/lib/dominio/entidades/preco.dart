
class Preco {
  int? id;
  int? quantidade;
  int? idProduto;
  double? preco;
  Preco(
      {this.id,
      required this.quantidade,
      required this.idProduto,
      required this.preco});

      Preco.fromJson(Map json) {
    id = json['id'];
    idProduto = json['id_produto'];
    preco = json['preco'];
    quantidade = json['quantidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_produto'] = this.idProduto;
    data['preco'] = this.preco;
    data['quantidade'] = this.quantidade;
    return data;
  }
  
}
