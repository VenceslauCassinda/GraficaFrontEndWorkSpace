import 'dart:convert';

import 'package:http/http.dart' as h;
import '../../contratos/provedores/provedor_servico_i.dart';
import '../../dominio/entidades/servico.dart';
import '../../recursos/constantes.dart';
import '../erros.dart';

class ProvedorNetServico implements ProvedorServicoI {
  @override
  Future<int> registarServico(Servico dado) async {
    int id = -1;
    
    var res = await h.post(
      Uri.parse(URL_ADD_SERVICO),
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      },
      body: {
        "servico": "${dado.servico}",
        "tipo": "${dado.tipo}",
        "descricao": "${dado.descricao}",
      },
    );

    // mostrar(res.statusCode);
    // mostrar(res.body);
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        id = dado["dado"]["id"];
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
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future<int> atualizarServico(Servico dado) async {
    int id = -1;
    var res =
        await h.post(Uri.parse("$URL_ATUALIZAR_SERVICO/${dado.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "servico": "${dado.servico}",
      "tipo": "${dado.tipo}",
      "descricao": "${dado.descricao}",
    });
    // mostrar(res.body);
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        id = dado["dado"]["id"];
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
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future<List<Servico>> pegarListaServico() async {
    var lista = <Servico>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_SERVICO),
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      },
    );
    // mostrar(res.statusCode);
    // mostrar(res.body);
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        List todos = dado["todos"];
        for (Map cada in todos) {
          try {
            lista.add(Servico.fromJson(cada));
          } on Exception catch (e) {
            throw Erro("Erro na conversão dos dados baixados do servidor!");
          }
        }
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
      default:
        throw Erro("Falha de Servidor!");
    }
    return lista;
  }

  @override
  Future<int> removerServicoDeId(int id) async {
    var res = await h.post(
      Uri.parse("$URL_REMOVER_SERVICO/$id/"),
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      },
    );
    // mostrar(res.body);
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
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
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }
  
}