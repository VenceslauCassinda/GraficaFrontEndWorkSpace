import 'package:grafica_frontend/dominio/entidades/forma_pagamento.dart';

import 'pagamento_final.dart';

class Comprovativo {
  int? id;
  int? idPagamento;
  String? link;
  String? descricao;

  Comprovativo(
      {this.id,
      this.idPagamento,
      this.link,
      this.descricao,
      });
  
  Comprovativo.fromJson(Map json) {
    idPagamento = json['id_pagamento'];
    link = json['link'];
    descricao = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_pagamento'] = this.idPagamento;
    data['link'] = this.link;
    data['descricao'] = this.descricao;
    data['id'] = this.id;
    return data;
  }
}
