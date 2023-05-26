import 'produto.dart';

class DetalheItem {
  int? id;
  int? idItem;
  int? idExemplar;
  String? idVista;
  String? frente;
  String? tras;
  String? tema;
  String? corLetras;
  
  DetalheItem(
      {this.id,
      required this.idItem,
      this.idExemplar,
      this.corLetras,
      this.idVista,
      required this.frente,
      required this.tras,
      required this.tema});

  DetalheItem.fromJson(Map json) {
    idItem = json['id_produto'];
    idExemplar = json['id_pedido'];
    tras = json['tras'];
    tema = json['tema'];
    corLetras = json['cor_letras'];
    frente = json['frente'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_produto'] = this.idItem;
    data['id_pedido'] = this.idExemplar;
    data['tras'] = this.tras;
    data['cor_letras'] = this.corLetras;
    data['tema'] = this.tema;
    data['frente'] = this.frente;
    data['id'] = this.id;
    return data;
  }
}
