import 'dart:convert';

import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_cliente_i.dart';
import 'package:grafica_frontend/dominio/entidades/cliente.dart';
import 'package:http/http.dart' as h;
import '../../recursos/constantes.dart';
import '../../solucoes_uteis/console.dart';
import '../erros.dart';

class ProvedorNetCliente implements ProvedorClienteI {
  @override
  Future<bool> actualizaCliente(Cliente dado) async {
    var res = await h.post(Uri.parse("$URL_ATUALIZAR_CLIENTE/${dado.id}/"), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "nome_completo": dado.idUsuario??"Sem Nome",
        "numero": dado.numero??"Sem Númro",
        "id_usuario": "${dado.idUsuario??-1}",
        "estado": "${dado.estado}",
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
  Future<int> adicionarCliente(Cliente dado)async {
    int id = -1;
    var res = await h.post(Uri.parse(URL_ADD_CLIENTE), 
      headers: {
        "Accept": "aplication/json",
        "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
      }, 
      body: {
        "nome_completo": dado.nome??"Sem Nome",
        "numero": dado.numero??"Sem Númro",
        "id_usuario": "${dado.idUsuario??-1}",
        "estado": "${dado.estado}",
      }
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
  Future<bool> existeCliente(String nome, String numero) async{
    var usuario = (await todos()).firstWhereOrNull((element) => element.nome == nome && element.numero == numero) != null;
    return  usuario;
  }

  @override
  Future<Cliente?> pegarClienteDeId(int id)async {
    return (await todos()).firstWhereOrNull((element) => element.id == id);
  }

  @override
  Future<void> removerCliente(Cliente dado)async{
    var res = await h.post(Uri.parse("$URL_REMOVER_CLIENTE/${dado.id}/"), 
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
  Future<void> removerTudo() async{
    var res  = await todos();
    for (var cada in res) {
      await removerCliente(cada);
    }
  }

  @override
  Future<List<Cliente>> todos()async{
    var lista = <Cliente>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_CLIENTE),
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
            lista.add(Cliente.fromJson(cada));
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