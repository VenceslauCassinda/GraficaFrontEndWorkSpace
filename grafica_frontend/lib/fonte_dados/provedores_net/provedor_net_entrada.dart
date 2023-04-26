import 'dart:convert';
import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_entrada_i.dart';
import 'package:grafica_frontend/dominio/entidades/entrada.dart';
import 'package:grafica_frontend/fonte_dados/provedores_net/provedor_net_produto.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:http/http.dart' as h;
import 'package:grafica_frontend/contratos/provedores/provedor_preco_i.dart';
import 'package:grafica_frontend/dominio/entidades/preco.dart';
import '../../recursos/constantes.dart';
import '../erros.dart';

class ProvedorNetEntrada implements ProvedorEntradaI{
  @override
  Future<int> actualizarEntrada(Entrada entrada)async {
    var res = await h.post(Uri.parse("$URL_ATUALIZAR_ENTRADA/${entrada.id}/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "id_produto": "${entrada.idProduto??-1}",
        "id_funcionario": "${entrada.idFuncionario??-1}",
        "quantidade": "${entrada.quantidade}",
        "data": "${entrada.data}",
        "motivo": "${entrada.motivo}",
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
        case 500:
        throw Erro("Bando de Dados Indisponível!");
      default:
        throw Erro("Falha de Servidor!");
    }
    return entrada.id??-1;
  }

  @override
  Future<Entrada?> pegarEntradaDeProdutoDeId(int id) async{
    var res = await pegarLista();
    return res.firstWhereOrNull((element) => id == element.idProduto);
  }

  @override
  Future<List<Entrada>> pegarLista() async{
    var lista = <Entrada>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_ENTRADAS),
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
            var entrada = Entrada.fromJson(cada);
            entrada.produto = await ProvedorNetProduto().pegarProdutoDeId(entrada.idProduto!);
            lista.add(entrada);
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
  Future<List<Entrada>> pegarListaDoProduto(int idProduto)async {
    List<Entrada> lista = [];
    var res = await pegarLista();
    for (var cada in res) {
      if(cada.idProduto == idProduto){
        lista.add(cada);
      }
    }
    return lista;
  }

  @override
  Future<List<Entrada>> pegarListaEntradasFuncionario(int idFuncionario)async {
    List<Entrada> lista = [];
    var res = await pegarLista();
    for (var cada in res) {
      if(cada.idFuncionario == idFuncionario){
        lista.add(cada);
      }
    }
    return lista;
  }

  @override
  Future<int> registarEntrada(Entrada entrada) async{
    int id = -1;
    var res = await h.post(Uri.parse(URL_ADD_ENTRADA), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "id_produto": "${entrada.idProduto??-1}",
        "quantidade": "${entrada.quantidade}",
        "id_funcionario": "${entrada.idFuncionario??-1}",
        "data": "${entrada.data}",
        "motivo": "${entrada.motivo}",
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
  Future removerAntes(DateTime data) async{
    var res = await pegarLista();
    for (var cada in res) {
      if (cada.data!.isBefore(data)) {
        await remover(cada.id!);
      }
    }
  }

  @override
  Future removerTudo()async {
    var res = await pegarLista();
    for (var cada in res) {
      await remover(cada.id!);
    }
  }
  
  @override
  Future remover(int id) async{
    var dado = await pegarEntradaDeId(id);
    if (dado ==null) {
      throw Erro("Não Existe!");
    }
    mostrar(dado.toJson());
    var res = await h.post(Uri.parse("$URL_REMOVER_ENTRADA/${dado.id}/"), 
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
  
  @override
  Future<Entrada?> pegarEntradaDeId(int id) async{
    var res = await pegarLista();
    return res.firstWhereOrNull((element) => id == element.id);
  }
  
  
}