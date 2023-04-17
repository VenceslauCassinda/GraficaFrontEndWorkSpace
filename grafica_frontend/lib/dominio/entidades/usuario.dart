class Usuario {
  int? id;
  String? nomeUsuario;
  String? imagemPerfil;
  String? palavraPasse;
  int? nivelAcesso;
  int? estado;
  bool? logado;

  Usuario.registo(this.nomeUsuario, this.palavraPasse, [this.nivelAcesso]);

  Usuario(
      {this.id,
      this.estado,
      this.logado,
      this.nomeUsuario,
      this.imagemPerfil,
      this.palavraPasse,
      this.nivelAcesso});

  Usuario.fromJson(Map json) {
    id = json['id'];
    nomeUsuario = json['name'];
    imagemPerfil = json['imagem'];
    logado = json['logado'] == 1;
    estado = json['estado'];
    nivelAcesso = json['nivel_acesso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.nomeUsuario;
    data['imagem'] = this.imagemPerfil;
    data['logado'] = this.logado;
    data['estado'] = this.estado;
    data['nivel_acesso'] = this.nivelAcesso;
    return data;
  }
}
