import 'dart:convert';
import 'package:get/get.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:http/http.dart' as h;
import 'package:grafica_frontend/contratos/provedores/provedor_preco_i.dart';
import 'package:grafica_frontend/dominio/entidades/preco.dart';
import '../../recursos/constantes.dart';
import '../erros.dart';

class ProvedorNetPreco implements ProvedorPrecoI{
  @override
  Future<int> adicionarPrecoProduto(Preco preco)async {
    int id = -1;
    var res = await h.post(Uri.parse(URL_ADD_PRECO), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "id_produto": "${preco.idProduto??-1}",
        "preco": "${preco.preco}",
        "quantidade": "${preco.quantidade}",
      }
    );
    
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
  Future<bool> atualizarPrecoProduto(Preco preco) async{
    var res = await h.post(Uri.parse("$URL_ATUALIZAR_STOCK/${preco.id}/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "id_produto": "${preco.idProduto}",
        "preco": "${preco.preco}",
        "quantidade": "${preco.quantidade}",
      }
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
    return true;
  }

  @override
  Future<bool> existeProdutoComPreco(double preco, int idProduto)async {
    var lista = await pegarLista();
    var teste =
        lista.firstWhereOrNull((element) => element.preco == preco && element.idProduto == idProduto);
    return teste != null;
  }

  @override
  Future<List<Preco>> pegarPrecoProdutoDeId(int id) async{
    var lista = await pegarLista();
    var precos = <Preco>[];
    for (var element in lista) {
      if(element.idProduto == id){
        precos.add(element);
      }
    }
    return precos;
  }
  
  Future<Preco> pegarUmPrecoProdutoDeId(double preco, int idProduto) async{
    var lista = await pegarLista();
    return lista.firstWhere((element) => element.preco == preco && element.idProduto == idProduto);
  }

  @override
  Future<void> removerPrecoProduto(double preco, int idProduto) async{
    var dado = await pegarUmPrecoProdutoDeId(preco, idProduto);
    mostrar(dado.toJson());
    var res = await h.post(Uri.parse("$URL_REMOVER_PRECO/${dado.id}/"), 
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
  }

  Future<List<Preco>> pegarLista() async{
    var lista = <Preco>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_PRECOS),
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
            lista.add(Preco.fromJson(cada));
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
  
}