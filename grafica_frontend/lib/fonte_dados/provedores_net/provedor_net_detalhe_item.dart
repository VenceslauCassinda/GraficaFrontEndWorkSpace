import 'dart:convert';

import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/tipo_detalhe.dart';
import 'package:http/http.dart' as h;
import '../../contratos/provedores/provedor_detalhe_item.dart';
import '../../dominio/entidades/detalhe_item.dart';
import '../../recursos/constantes.dart';
import '../../solucoes_uteis/console.dart';
import '../../vista/aplicacao_c.dart';
import '../erros.dart';
import 'package:http_parser/http_parser.dart';

class ProvedorNetDetalheItem implements ProvedorDetalheItemI {
  Future<String> fazerUpload(List<int> bytesDoArquivo, String extensao) async {
    var requisicao =
        h.MultipartRequest("post", Uri.parse(URL_UPLOAD_EXEMPLAR));
      String nomeArquivo =
          "Exempla-${pegarAplicacaoC().pegarUsuarioActual()!.nomeUsuario}-${formatarData(DateTime.now(),).replaceAll(" ", "_")}";
      requisicao.files.add(await h.MultipartFile.fromBytes("file", bytesDoArquivo,
          contentType: MediaType(
            "aplication",
            "json",
          ),
          filename: extensao));
    var res = await requisicao.send();
    if (res.statusCode != 200) {
      throw Erro(
          "${res.statusCode.toString()} -- ${res.reasonPhrase!.toString()}");
    }
    var mapa = jsonDecode(await res.stream.bytesToString());
    return mapa["url"];
  }

  @override
  Future<bool> actualizaDetalheItem(DetalheItem dado) async {
    var res = await h.post(Uri.parse("$URL_ATUALIZAR_DETALHE_ITEM/${dado.id}/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "id_item": "${dado.idItem??-1}",
        "link": dado.link??"",
        "id_tipo": "${dado.tipo??0}",
        "nome_cor": dado.nomeCor??"",
        "dizeres": dado.dizeres??"",
        "detalhe": dado.detalhe??"",
      }
    );
    // mostrar(res.body);
    switch (res.statusCode) {
      case 200: 
        var dado = jsonDecode(res.body);
        return true;
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
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
  }

  @override
  Future<DetalheItem?> pegarDetalheItemDeId(int id) async {
    return (await todos()).firstWhereOrNull((element) => element.id == id);
  }
  

  @override
  Future<int> registarDetalheItem(DetalheItem dado)  async {
    int id = -1;
    var url = "SemURL";
    if(dado.arquivo != null){
      url = await fazerUpload(dado.arquivo!.bytes!, dado.arquivo!.name);
    }
    var res = await h.post(Uri.parse("$URL_ADD_DETALHE_ITEM/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "id_item": "${dado.idItem??-1}",
        "link": url,
        "id_tipo": "${dado.tipo??0}",
        "nome_cor": "${dado.nomeCor}",
        "dizeres": "${dado.dizeres}",
        "detalhe": "${dado.detalhe}",
      }
    );
    // mostrar(res.body);
    // mostrar(res.statusCode);
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
        case 500:
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future<int> removerDetalheItem(DetalheItem dado)async{
    var res = await h.post(Uri.parse("$URL_REMOVER_DETALHE_ITEM/${dado.id}/"), 
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
        case 500:
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
    return dado.id!;
  }

  @override
  Future<List<DetalheItem>> todos()async{
    var lista = <DetalheItem>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_DETALHE_ITEM),
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
            lista.add(DetalheItem.fromJson(cada));
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
        case 500:
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
    return lista;
  }

  @override
  Future<int> actualizarTipoDetalhe(TipoDetalhe dado) async {
    var res = await h.post(Uri.parse("$URL_ATUALIZAR_TIPO_DETALHE/${dado.id}/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "tipo": "${dado.tipo??0}",
        "tipo_produto": "${dado.tipoProduto??0}",
        "detalhe": dado.detalhe??"",
      }
    );
    // mostrar(res.body);
    switch (res.statusCode) {
      case 200: 
        var dados = jsonDecode(res.body);
        return dado.id??-1;
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
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
  }

  @override
  Future<List<TipoDetalhe>> pegarListaTipoDetalhe()async{
    var lista = <TipoDetalhe>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_TIPO_DETALHE),
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
            lista.add(TipoDetalhe.fromJson(cada));
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
        case 500:
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
    return lista;
  }

  @override
  Future<TipoDetalhe?> pegarTipoDetalheDeId(int id) async {
    return (await pegarListaTipoDetalhe()).firstWhereOrNull((element) => element.id == id);
  }

  @override
  Future<int> registarTipoDetalhe(TipoDetalhe dado) async {
    int id = -1;
    var res = await h.post(Uri.parse("$URL_ADD_TIPO_DETALHE/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "tipo": "${dado.tipo??0}",
        "tipo_produto": "${dado.tipoProduto??0}",
        "detalhe": dado.detalhe??"",
      }
    );
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
        case 500:
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future<int> removerTipoDetalhe(int idDado)async{
    var res = await h.post(Uri.parse("$URL_REMOVER_TIPO_DETALHE/$idDado/"), 
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
        case 500:
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
    return idDado;
  }
  
  @override
  Future<List<DetalheItem>> pegarDetalhesDeItemId(int id) async{
    var lista = <DetalheItem>[];
    for (var cada in await todos()) {
      if (cada.idItem == id) {
        lista.add(cada);
      }
    }
    return lista;
  }
  
  @override
  Future<List<TipoDetalhe>> pegarTipoDetalhesDeTipoProduto(int tipoProduto) async{
    var lista = <TipoDetalhe>[];
    for (var cada in await pegarListaTipoDetalhe()) {
      if (cada.tipoProduto == tipoProduto) {
        lista.add(cada);
      }
    }
    return lista;
  }
  
}