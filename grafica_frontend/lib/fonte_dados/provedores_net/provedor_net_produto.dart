import 'dart:convert';

import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_produto_i.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';
import 'package:http/http.dart' as h;
import '../../recursos/constantes.dart';
import '../../solucoes_uteis/console.dart';
import '../erros.dart';

class ProvedorNetProduto implements ProvedorProdutoI{
  @override
  Future<void> actualizarProduto(Produto dado) async{
    var res = await h.post(Uri.parse("$URL_ATUALIZAR_PRODUTO/${dado.id}/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "nome": dado.nome??"",
        "estado": "${dado.estado??0}",
        "preco_compra": "${dado.precoCompra??0}",
        "recebivel": "${dado.recebivel == true? 1 : 0}",
      }
    );
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
  Future<int> adicionarProduto(Produto dado) async{
    int id = -1;
    var res = await h.post(Uri.parse(URL_ADD_PRODUTO), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "nome": dado.nome??"",
        "estado": "${dado.estado??0}",
        "preco_compra": "${dado.precoCompra??0}",
        "recebivel": "${dado.recebivel == true? 1 : 0}",
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
        case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future<bool> existeProdutoComNome(String nome) async{
    var lista = await pegarLista();
    var teste =
        lista.firstWhereOrNull((element) => element.nome == nome);
    return teste != null;
  }

  @override
  Future<bool> existeProdutoDiferenteDeNome(int id, String nomeProduto) async{
    var lista = await pegarLista();
    var teste =
        lista.firstWhereOrNull((element) => element.nome == nomeProduto && id != element.id);
    return teste != null;
  }

  @override
  Future<List<Produto>> pegarLista() async{
    var lista = <Produto>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_PRODUTO),
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      },
    );
    switch (res.statusCode) {
      case 200:
        var dado = jsonDecode(res.body);
        List todos = dado["todos"];
        for (Map cada in todos) {
          try {
            lista.add(Produto.fromJson(cada));
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

  @override
  Future<Produto?> pegarProdutoDeId(int id) async {
    var lista = await pegarLista();
    return lista.firstWhere((element) => element.id == id);
  }

  @override
  Future<void> removerProduto(Produto dado) async{
    var res = await h.post(Uri.parse("$URL_REMOVER_PRODUTO/${dado.id}/"), 
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
  
}