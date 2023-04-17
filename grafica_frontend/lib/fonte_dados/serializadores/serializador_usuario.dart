import 'package:grafica_frontend/dominio/entidades/estado.dart';
import 'package:grafica_frontend/dominio/entidades/nivel_acesso.dart';
import 'package:grafica_frontend/dominio/entidades/usuario.dart';

class SerializadorUsuario {
  Map toJson(Usuario model) {
    return {
      "id": model.id,
      "nome_usuario": model.nomeUsuario,
      "logado": model.logado,
      "nivel_acesso": model.nivelAcesso,
      "palavra_passe": model.palavraPasse,
      "imagem_perfil": model.imagemPerfil,
    };
  }

  Usuario fromJson(Map json) {
    return Usuario(
      id: json["id"],
      nomeUsuario: json["id"],
      estado: json["estado"],
      logado: json["logado"],
      nivelAcesso: json["nivel_acesso"],
      palavraPasse: json["palavra_passe"],
      imagemPerfil: json["imagem_perfil"],
    );
  }

  Usuario fromTabela(tabela) {
    return Usuario(
      id: tabela.id,
      nomeUsuario: tabela.nomeUsuario,
      nivelAcesso: tabela.nivelAcesso,
      estado: tabela.estado ?? 0,
      logado: tabela.logado ?? false,
      palavraPasse: tabela.palavraPasse,
      imagemPerfil: tabela.imagemPerfil,
    );
  }

  toTabela(Usuario model) {
    return [
      model.id ?? -1,
      model.nomeUsuario!,
      model.logado ?? false,
      model.estado ?? Estado.ELIMINADO,
      model.nivelAcesso ?? NivelAcesso.FUNCIONARIO,
      model.palavraPasse!,
      model.imagemPerfil!,
    ];
  }

  toCompanion(Usuario model) {
    return 
      [model.nomeUsuario!,
      model.nivelAcesso ?? NivelAcesso.FUNCIONARIO,
      model.palavraPasse!,
      model.imagemPerfil ?? "",
    ];
  }
}
