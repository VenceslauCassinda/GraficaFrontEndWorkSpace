
class Cliente {
  int? id;
  int? idUsuario;
  int? estado;
  String? nome;
  String? numero;
  Cliente(
      {this.id,
      required this.estado,
      this.idUsuario,
      required this.nome,
      required this.numero});
  
  Cliente.fromJson(Map json) {
    idUsuario = json['id_usuario'];
    nome = json['nome_completo'];
    numero = json['numero'];
    estado = json['estado'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_usuario'] = this.idUsuario;
    data['nome_completo'] = this.nome;
    data['numero'] = this.numero;
    data['estado'] = this.estado;
    data['id'] = this.id;
    return data;
  }
}
