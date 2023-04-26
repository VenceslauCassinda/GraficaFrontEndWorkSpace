import 'dart:convert';
import 'package:http/http.dart' as h;
import 'package:grafica_frontend/dominio/entidades/stock.dart';
import 'package:grafica_frontend/fonte_dados/provedores/provedor_stock.dart';

import '../../recursos/constantes.dart';
import '../../solucoes_uteis/console.dart';
import '../erros.dart';

class ProvedorNetStock implements ProvedorStock {
  @override
  Future<void> alterarQuantidadeStock(int idProduto, int quantidade) async {
    var dado = await pegarStockDoProdutoDeId(idProduto);
    var res =
        await h.post(Uri.parse("$URL_ATUALIZAR_STOCK/${dado!.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id_produto": "$idProduto",
      "quantidade": "$quantidade",
    });
    // mostrar(res.statusCode);
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
  Future<int> inicializarStockProduto(int idProduto) async {
    int id = -1;
    var res = await h.post(Uri.parse(URL_ADD_STOCK), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id_produto": "$idProduto",
      "quantidade": "0",
    });
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
  Future<Stock?> pegarStockDeId(int id) async {
    var lista = await pegarLista();
    return lista.firstWhere((element) => element.id == id);
  }

  @override
  Future<Stock?> pegarStockDoProdutoDeId(int id) async {
    var lista = await pegarLista();
    return lista.firstWhere((element) => element.idProduto == id);
  }

  @override
  Future<void> removerProdutoStock(int id) async {
    var res = await h.post(
      Uri.parse("$URL_REMOVER_STOCK/$id/"),
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
  Future<void> removerStock(int id) async {
    var res = await h.post(
      Uri.parse("$URL_REMOVER_STOCK/$id/"),
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

  Future<List<Stock>> pegarLista() async {
    var lista = <Stock>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_STOCKS),
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
            lista.add(Stock.fromJson(cada));
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
