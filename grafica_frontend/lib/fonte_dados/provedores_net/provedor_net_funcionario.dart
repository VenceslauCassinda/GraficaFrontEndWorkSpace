import 'dart:convert';

import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_funcionario_i.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:http/http.dart' as h;

import '../../recursos/constantes.dart';
import '../../vista/aplicacao_c.dart';
import '../erros.dart';

class ProvedorNetFuncionario implements ProvedorFuncionarioI {
  @override
  Future<void> activarFuncionario(Funcionario dado) {
    // TODO: implement activarFuncionario
    throw UnimplementedError();
  }

  @override
  Future<void> actualizarFuncionario(Funcionario dado) async {
    var res = await h
        .post(Uri.parse("$URL_ATUALIZAR_FUNCIONARIO/${dado.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id_usuario": "${dado.idUsuario}",
      "nome_completo": dado.nomeCompelto ?? "",
      "estado": "${dado.estado}",
    });
    mostrar(res.body);
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
  Future<int> adicionarFuncionario(Funcionario dado) async {
    int id = -1;
    var res = await h.post(Uri.parse(URL_CADASTRO_FUNCIONARIO), headers: {
      "Accept": "aplication/json"
    }, body: {
      "nome_completo": dado.nomeCompelto ?? "",
      "id_usuario": "${dado.idUsuario ?? "-1"}",
      "estado": "1",
    });
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        id = dado["dado"]["id"];
        break;
      case 404:
        throw Erro("Rota Wen Não Encontrado!");
      case 422:
        var dado = jsonDecode(res.body);
        throw Erro(
            "Número de Atributos para requisição incompletos!\n${dado["message"]}");
      case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future<void> desactivarFuncionario(Funcionario dado) {
    // TODO: implement desactivarFuncionario
    throw UnimplementedError();
  }

  @override
  Future<bool> existeFuncionarioComNomeUsuario(String nomeUsuario) async {
    var lista = await pegarLista();
    var teste =
        lista.firstWhereOrNull((element) => element.nomeUsuario == nomeUsuario);
    return teste != null;
  }

  @override
  Future<Funcionario> pegarFuncionarioDeId(int id) async {
    var lista = await pegarLista();
    return lista.firstWhere((element) => element.id == id);
  }

  @override
  Future<Funcionario> pegarFuncionarioDeNome(String nomeCompleto) async {
    var lista = await pegarLista();
    return lista.firstWhere((element) => element.nomeCompelto == nomeCompleto);
  }

  @override
  Future<Funcionario> pegarFuncionarioDoUsuarioDeId(int id) async {
    var lista = await pegarLista();
    return lista.firstWhere((element) => element.idUsuario == id);
  }

  @override
  Future<int> pegarIdFuncionarioDeNome(String nomeCompleto) async {
    var lista = await pegarLista();
    return lista
            .firstWhere((element) => element.nomeCompelto == nomeCompleto)
            .id ??
        -1;
  }

  @override
  Future<List<Funcionario>> pegarLista() async {
    var lista = <Funcionario>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_FUNCIONARIOS),
      headers: {"Accept": "aplication/json"},
    );
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        List todos = dado["todos"];
        for (Map cada in todos) {
          try {
            lista.add(Funcionario.fromJson(cada));
          } on Exception catch (e) {
            throw Erro("Erro na conversão dos dados baixados do servidor!");
          }
        }
        break;
      case 404:
        throw Erro("Rota Wen Não Encontrado!");
      case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return lista;
  }

  @override
  Future<List<Funcionario>> pegarListaEliminados() {
    // TODO: implement pegarListaEliminados
    throw UnimplementedError();
  }

  @override
  Future<void> recuperarFuncionario(Funcionario dado) {
    // TODO: implement recuperarFuncionario
    throw UnimplementedError();
  }

  @override
  Future<void> removerFuncionario(Funcionario dado) async {
    var res = await h.post(
      Uri.parse("$URL_REMOVER_FUNCIONARIO/${dado.id}/"),
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      },
    );
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
  Future<List<Funcionario>> todos() async {
    return await pegarLista();
  }
}
