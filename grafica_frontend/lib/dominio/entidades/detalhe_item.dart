
import 'package:file_picker/file_picker.dart';


class DetalheItem {
  int? id;
  String? idVista;
  int? idItem;
  int? tipo;
  String? detalhe;
  String? dizeres;
  String? link;
  String? nomeCor;
  PlatformFile? arquivo;
  
  DetalheItem(
      {this.id,
      required this.idItem,
      this.link,
      this.idVista,
      this.tipo,
      this.nomeCor,
      this.detalhe,
      this.dizeres,
      this.arquivo,
      });

  DetalheItem.fromJson(Map json) {
    idItem = json['id_item'];
    detalhe = json['detalhe'];
    dizeres = json['dizeres'];
    link = json['link'];
    nomeCor = json['nome_cor'];
    tipo = json['tipo'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_item'] = this.idItem;
    data['detalhe'] = this.detalhe;
    data['dizeres'] = this.dizeres;
    data['link'] = this.link;
    data['nome_cor'] = this.nomeCor;
    data['tipo'] = this.tipo;
    return data;
  }
}
