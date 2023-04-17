class Stock {
  int? id;
  int? estado;
  int? idProduto;
  int? quantidade;
  Stock(
      {this.id,
      required this.estado,
      required this.idProduto,
      required this.quantidade});

  Stock.zerado() {
    quantidade = 0;
  }

  Stock.fromJson(Map json) {
    id = json['id'];
    idProduto = json['id_produto'];
    quantidade = json['quantidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_produto'] = this.idProduto;
    data['quantidade'] = this.quantidade;
    return data;
  }
}
