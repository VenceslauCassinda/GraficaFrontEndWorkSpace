import 'package:file_picker/file_picker.dart';

class Exemplar {
  int? id;
  int? idItem;
  String? link;
  String? descricao;
  PlatformFile? arquivo;

  Exemplar(
      {this.id,
      this.idItem,
      this.link,
      this.arquivo,
      this.descricao,
      });
  
  Exemplar.fromJson(Map json) {
    idItem = json['id_item'];
    link = json['link'];
    descricao = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_item'] = this.idItem;
    data['link'] = this.link;
    data['descricao'] = this.descricao;
    data['id'] = this.id;
    return data;
  }
}
