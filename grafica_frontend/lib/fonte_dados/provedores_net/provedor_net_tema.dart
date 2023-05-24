import 'dart:convert';

import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/vista/aplicacao_c.dart';
import 'package:http/http.dart' as h;
import '../../contratos/provedores/provedor_tema_i.dart';
import '../../dominio/entidades/tema.dart';
import '../../recursos/constantes.dart';
import '../erros.dart';
import 'package:http_parser/http_parser.dart';

class ProvedorNetTema implements ProvedorTemaI {
  
  @override
  Future<int> registarTema(Tema dado) async {
    int id = -1;
    
    var res = await h.post(
      Uri.parse(URL_ADD_TEMA),
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      },
      body: {
        "tema": "${dado.tema}",
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
  Future<int> atualizarTema(Tema dado) async {
    int id = -1;
    var res =
        await h.post(Uri.parse("$URL_ATUALIZAR_TEMA/${dado.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "tema": "${dado.tema}",
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
  Future<List<Tema>> pegarListaTema() async {
    var lista = <Tema>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_TEMA),
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
            lista.add(Tema.fromJson(cada));
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
  Future<int> removerTemaDeId(int id) async {
    var res = await h.post(
      Uri.parse("$URL_REMOVER_TEMA/$id/"),
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
