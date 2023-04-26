import 'dart:convert';

import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_usuario_i.dart';
import 'package:grafica_frontend/dominio/entidades/usuario.dart';
import 'package:grafica_frontend/fonte_dados/erros.dart';
import 'package:grafica_frontend/recursos/constantes.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/vista/aplicacao_c.dart';
import 'package:http/http.dart' as h;

class ProvedorNetUsuario implements ProvedorUsuarioI {
  @override
  Future<void> actualizarUsuario(Usuario usuario) async {
    var url = (usuario.palavraPasse == null || usuario.palavraPasse!.isEmpty)
        ? URL_ATUALIZAR_USUARIO
        : URL_ATUALIZAR_USUARIO_COM_PASS;
    var res = await h.post(Uri.parse("$url/${usuario.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "name": usuario.nomeUsuario ?? "",
      "estado": "${usuario.estado}",
      "nivel_acesso": "${usuario.nivelAcesso}",
      "logado": "${usuario.logado == true ? 1 : 2}",
      "password": usuario.palavraPasse ?? "",
    });
    switch (res.statusCode) {
      case 200:
        break;
      case 422:
        var dado = jsonDecode(res.body);
        throw Erro("Erro de Servidor!\n ${dado["message"]}");
      case 404:
        throw Erro("Rota Web Não Encontrada!");
      case 403:
        var dado = jsonDecode(res.body);
        throw Erro("${dado["message"]}");
      case 401:
        var dado = jsonDecode(res.body);
        throw Erro("${dado["message"]}");
      case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
  }

  @override
  Future<int> adicionarUsuario(Usuario usuario) async {
    if (await existeUsuarioComNomeUsuario(usuario.nomeUsuario!)) {
      throw ErroUsuarioJaExiste("NOME DE USUARIO JA EXISTENTE!");
    }

    int id = -1;
    var res = await h.post(Uri.parse(URL_CADASTRO_USUARIO), headers: {
      "Accept": "aplication/json"
    }, body: {
      "name": usuario.nomeUsuario ?? "",
      "estado": "1",
      "nivel_acesso": "0",
      "logado": "0",
      "password": usuario.palavraPasse ?? "",
    });
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        mostrar(dado);
        id = dado["dado"]["id"];
        break;
      case 422:
        var dado = jsonDecode(res.body);
        throw Erro("Erro de Servidor!\n${dado["message"]}");
      case 404:
        throw Erro("Rota Web Não Encontrada!");
      case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future<bool> existeUsuarioComNomeUsuario(String nomeUsuario) async {
    var lista = await pegarLista();
    var teste =
        lista.firstWhereOrNull((element) => element.nomeUsuario == nomeUsuario);
    return teste != null;
  }

  @override
  Future<Usuario?> fazerLogin(String nomeUsuario, String palavraPasse) async {
    int id = -1;
    var res = await h.post(Uri.parse(URL_LOGIN), headers: {
      "Accept": "aplication/json"
    }, body: {
      "name": "$nomeUsuario",
      "password": "$palavraPasse",
    });
    mostrar(res.statusCode);
    mostrar(res.body);
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        id = dado["dado"]["id"];
        TOKEN_USUARIO_ATUAL = dado["token"];
        break;
      case 422:
        var dado = jsonDecode(res.body);
        throw Erro("Erro de Servidor!\n ${dado["message"]}");
      case 404:
        throw Erro("Rota Web Não Encontrada!");
      case 403:
        var dado = jsonDecode(res.body);
        throw Erro("${dado["message"]}");
      case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    mostrar("LOGADO COM $TOKEN_USUARIO_ATUAL");
    return await pegarUsuario(id);
  }

  @override
  Future<Usuario?> pegarUsuario(int id) async {
    var lista = await pegarLista();
    return lista.firstWhereOrNull((element) => element.id == id);
  }

  @override
  Future<List<Usuario>> pegarLista() async {
    var lista = <Usuario>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_USUARIOS),
      headers: {"Accept": "aplication/json"},
    );
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        List todos = dado["todos"];
        for (Map cada in todos) {
          try {
            lista.add(Usuario.fromJson(cada));
          } on Exception catch (e) {
            throw Erro("Erro na conversão dos dados baixados do servidor!");
          }
        }
        break;
      case 404:
        throw Erro("Rota Web Não Encontrada!");
      case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return lista;
  }

  @override
  Future<List<Usuario>> pegarListaEliminados() {
    // TODO: implement pegarListaEliminados
    throw UnimplementedError();
  }

  @override
  Future<void> removerUsuario(Usuario usuario) async {
    var res = await h
        .post(Uri.parse("$URL_REMOVER_USUARIO/${usuario.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id": "${pegarAplicacaoC().pegarUsuarioActual()?.id ?? -1}",
      "nivel_acesso": "${usuario.nivelAcesso}",
    });
    // mostrar(res.body);
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        mostrar(dado);
        break;
      case 422:
        var dado = jsonDecode(res.body);
        throw Erro("Erro de Servidor!\n ${dado["message"]}");
      case 404:
        throw Erro("Rota Web Não Encontrada!");
      case 403:
        var dado = jsonDecode(res.body);
        throw Erro("${dado["message"]}");
      case 401:
        var dado = jsonDecode(res.body);
        throw Erro("${dado["message"]}");
      case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
  }

  @override
  Future<void> terminarSessao(Usuario usuario) async {
    var res = await h.post(
      Uri.parse(URL_TERMINAR_SESSAO),
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      },
    );
    switch (res.statusCode) {
      case 200:
        TOKEN_USUARIO_ATUAL = "SemToken";
        break;
      case 422:
        var dado = jsonDecode(res.body);
        throw Erro("Erro de Servidor!\n ${dado["message"]}");
      case 404:
        throw Erro("Rota Web Não Encontrada!");
      case 403:
        var dado = jsonDecode(res.body);
        throw Erro("${dado["message"]}");
      case 401:
        var dado = jsonDecode(res.body);
        throw Erro("${dado["message"]}");
      case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
  }
}
