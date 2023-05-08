import 'dart:convert';

import 'package:grafica_frontend/dominio/entidades/comprovativo.dart';
import 'package:http/http.dart' as h;
import '../../contratos/provedores/provedor_comprovativo_i.dart';
import '../../recursos/constantes.dart';
import '../erros.dart';
import 'package:http_parser/http_parser.dart';

class ProvedorNetComprovativo implements ProvedorComprovativoI {
  Future<void> fazerUploadComprovativo(
      List<int> bytesDoArquivo, String nomeArquivo) async {
    // var res = await h.post(
    //   Uri.parse(URL_UPLOAD_COMPROVATIVO),
    //   headers: {
    //     "Accept": "aplication/json",
    //   },
    // );
    var requisicao =
        h.MultipartRequest("post", Uri.parse(URL_UPLOAD_COMPROVATIVO));
    requisicao.files.add(h.MultipartFile.fromBytes("file", bytesDoArquivo,
        contentType: MediaType(
          "aplication",
          "json",
        ),
        filename: nomeArquivo));
    var res = await requisicao.send();
    if (res.statusCode != 200) {
    }
      throw Erro(
          "${res.statusCode.toString()} -- ${res.reasonPhrase!.toString()}");
  }

  @override
  Future<int> registarComprovativo(Comprovativo dado) async {
    int id = -1;
    var res = await h.post(
      Uri.parse(URL_ADD_COMPROVATIVO),
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      },
      body: {
        "id_pagamento": "${dado.idPagamento}",
        "link": "${dado.link}",
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
  Future<int> atualizarComprovativo(Comprovativo dado) async {
    int id = -1;
    var res =
        await h.post(Uri.parse("$URL_ATUALIZAR_CLIENTE/${dado.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id_pagamento": "${dado.idPagamento}",
      "link": "${dado.link}",
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
  Future<List<Comprovativo>> pegarListaComprovativo() async {
    var lista = <Comprovativo>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_COMPROVATIVO),
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
            lista.add(Comprovativo.fromJson(cada));
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
  Future<int> removerComprovativoDeId(int id) async {
    var res = await h.post(
      Uri.parse("$URL_REMOVER_COMPROVATIVO/$id/"),
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
