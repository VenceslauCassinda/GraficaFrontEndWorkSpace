import 'dart:convert';

import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_item_venda_i.dart';
import 'package:grafica_frontend/dominio/entidades/item_venda.dart';
import 'package:http/http.dart' as h;
import '../../recursos/constantes.dart';
import '../erros.dart';

class ProvedorNetItemVenda implements ProvedorItemVendaI {
  @override
  Future<bool> actualizaItemVenda(ItemVenda dado) async {
    var res = await h.post(Uri.parse("$URL_ATUALIZAR_ITEM_PEDIDO/${dado.id}/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "id_produto": "${dado.idProduto??-1}",
        "id_pedido": "${dado.idVenda??-1}",
        "quantidade": "${dado.quantidade}",
        "total": "${dado.total}",
        "desconto": "${dado.desconto}",
        "estado": "${dado.estado??0}",
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
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
  }

  @override
  Future<ItemVenda?> pegarItemVendaDeId(int id) async {
    return (await todos()).firstWhereOrNull((element) => element.id == id);
  }

  @override
  Future<int> registarItemVenda(ItemVenda dado)  async {
    int id = -1;
    var res = await h.post(Uri.parse("$URL_ADD_ITEM_PEDIDO/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "id_produto": "${dado.idProduto??-1}",
        "id_pedido": "${dado.idVenda??-1}",
        "quantidade": "${dado.quantidade}",
        "total": "${dado.total}",
        "desconto": "${dado.desconto}",
        "estado": "${dado.estado??0}",
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
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future<int> removerItemVenda(ItemVenda dado)async{
    var res = await h.post(Uri.parse("$URL_REMOVER_ITEM_PEDIDO/${dado.id}/"), 
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
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return dado.id!;
  }

  @override
  Future<List<ItemVenda>> todos()async{
    var lista = <ItemVenda>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_ITEM_PEDIDO),
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
            lista.add(ItemVenda.fromJson(cada));
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
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return lista;
  }
  
}