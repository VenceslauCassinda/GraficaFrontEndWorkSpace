import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/dominio/entidades/usuario.dart';

class SerializadorFuncionario {
  Map toJson(Funcionario model) {
    return {
      "id": model.id,
      "nome_usuario": model.nomeUsuario,
      "nome_completo": model.nomeUsuario,
      "logado": model.logado,
      "nivel_acesso": model.nivelAcesso,
      "palavra_passe": model.palavraPasse,
      "imagem_perfil": model.imagemPerfil,
    };
  }

  Funcionario fromJson(Map json) {
    return Funcionario(
      nomeCompelto: json["nome_completo"],
      id: json["id"],
      nomeUsuario: json["id"],
      estado: json["estado"],
      logado: json["logado"],
      nivelAcesso: json["nivel_acesso"],
      palavraPasse: json["palavra_passe"],
      imagemPerfil: json["imagem_perfil"],
    );
  }

  Funcionario fromTabela(tabela,
      {usuario}) {
    return Funcionario(
      id: tabela.id,
      idUsuario: usuario?.id,
      imagemPerfil: usuario?.imagemPerfil,
      logado: usuario?.logado,
      nomeUsuario: usuario?.nomeUsuario,
      estado: usuario?.estado,
      nivelAcesso: usuario?.nivelAcesso,
      nomeCompelto: tabela.nomeCompleto,
    );
  }

  toTabela(Funcionario model) {
    return 
      [model.idUsuario ?? -1,
       model.id ?? -1,
       model.nomeCompelto!,
       model.estado!,
    ];
  }

  toCompanion(Funcionario model) {
    return 
      [model.idUsuario ?? -1,
      model.nomeCompelto!,
      model.estado ?? 0,
    ];
  }
}
