
class Funcionario {
  String? nomeCompelto;
  int? id;
  int? idUsuario;
  String? nomeUsuario;
  String? imagemPerfil;
  String? palavraPasse;
  int? nivelAcesso;
  int? estado;
  bool? logado;

  Funcionario(
      {this.nomeCompelto,
      this.id,
      this.estado,
      this.logado,
      this.idUsuario,
      this.nomeUsuario,
      this.imagemPerfil,
      this.palavraPasse,
      this.nivelAcesso})
      ;

      Funcionario.fromJson(Map json) {
    id = json['id'];
    idUsuario = json['id_usuario'];
    nomeCompelto = json['nome_completo'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_usuario'] = this.idUsuario;
    data['nome_completo'] = this.nomeCompelto;
    data['estado'] = this.estado;
    return data;
  }

  @override
  String toString() {
    return (StringBuffer('TabelaFuncionarioCompanion(')
          ..write('id: $id, ')
          ..write('estado: $estado, ')
          ..write('idUsuario: $idUsuario, ')
          ..write(
            'logado: $logado, ',
          )
          ..write(
            'nivelAcesso: $nivelAcesso, ',
          )
          ..write(
            'palavraPasse: $palavraPasse, ',
          )
          ..write(
            'imagemPerfil: $imagemPerfil, ',
          )
          ..write(
            'nomeCompleto: $nomeCompelto, ',
          )
          ..write(')'))
        .toString();
  }
}
