
import 'package:file_picker/file_picker.dart';


class TipoDetalhe {
  int? id;
  int? tipo;
  int? tipoProduto;
  String? detalhe;
  static int TEXTO = 0;
  static int IMAGEM = 1;
  static int COR = 2;
  
  TipoDetalhe(
      {this.id,
      this.tipo,
      this.tipoProduto,
      this.detalhe,
      });

  TipoDetalhe.fromJson(Map json) {
    detalhe = json['detalhe'];
    tipo = json['tipo'];
    tipoProduto = json['tipo_produto'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detalhe'] = this.detalhe;
    data['tipo_produto'] = this.tipoProduto;
    return data;
  }

  static String paraTexto(int id) {
    if (id == COR) {
      return "Cor";
    }
    if (id == IMAGEM) {
      return "Imagem";
    }
      return "Texto";
  }

  static int paraInteiro(String id) {
    if (id == "Cor") {
      return COR;
    }
    if (id == "Imagem") {
      return IMAGEM;
    }
      return TEXTO;
  }
}
