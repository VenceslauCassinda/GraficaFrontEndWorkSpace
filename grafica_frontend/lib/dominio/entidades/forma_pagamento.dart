
class FormaPagamento{
  int? id;
  int? estado;
  int? tipo;
  String? descricao;
  FormaPagamento(
      {this.id,
      this.estado,
      this.tipo,
      this.descricao});

  FormaPagamento.fromJson(Map json) {
    tipo = json['forma'];
    descricao = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forma'] = this.tipo;
    data['descricao'] = this.descricao;
    data['id'] = this.id;
    return data;
  }
}