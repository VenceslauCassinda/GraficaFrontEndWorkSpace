import 'dart:convert';

import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_saida_i.dart';
import 'package:grafica_frontend/dominio/entidades/saida.dart';
import 'package:http/http.dart' as h;
import '../../recursos/constantes.dart';
import '../../solucoes_uteis/console.dart';
import '../erros.dart';
import 'provedor_net_produto.dart';

class ProvedorNetSaida implements ProvedorSaidaI {
  @override
  Future<int> actualizarSaida(Saida saida) async {
    var res =
        await h.post(Uri.parse("$URL_ATUALIZAR_SAIDA/${saida.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id_produto": "${saida.idProduto ?? -1}",
      "id_funcionario": "${saida.idFuncionario ?? -1}",
      "quantidade": "${saida.quantidade}",
      "motivo": "${saida.motivo}",
    });
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
    return saida.id ?? -1;
  }

  @override
  Future<List<Saida>> pegarLista() async {
    var lista = <Saida>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_SAIDAS),
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
            var entrada = Saida.fromJson(cada);
            entrada.produto =
                await ProvedorNetProduto().pegarProdutoDeId(entrada.idProduto!);
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
      case 500:
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
    return lista;
  }

  @override
  Future<List<Saida>> pegarListaDoProduto(int idProduto) async {
    List<Saida> lista = [];
    var res = await pegarLista();
    for (var cada in res) {
      if (cada.idProduto == idProduto) {
        lista.add(cada);
      }
    }
    return lista;
  }

  @override
  Future<List<Saida>> pegarListaSaidasFuncionario(int idFuncionario) async {
    List<Saida> lista = [];
    var res = await pegarLista();
    for (var cada in res) {
      if (cada.idFuncionario == idFuncionario) {
        lista.add(cada);
      }
    }
    return lista;
  }

  @override
  Future<Saida?> pegarSaidaDeId(int id) async {
    var res = await pegarLista();
    return res.firstWhereOrNull((element) => id == element.id);
  }

  @override
  Future<Saida?> pegarSaidaDeProdutoDeId(int id) async {
    var res = await pegarLista();
    return res.firstWhereOrNull((element) => id == element.idProduto);
  }

  @override
  Future<Saida?> pegarSaidaDeProdutoDeIdEmotivo(int id, String motivo) async {
    var res = await pegarLista();
    return res.firstWhereOrNull(
        (element) => id == element.idProduto && motivo == element.motivo);
  }

  @override
  Future<int> registarSaida(Saida saida) async {
    int id = -1;
    var res = await h.post(Uri.parse(URL_ADD_SAIDA), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id_produto": "${saida.idProduto ?? -1}",
      "quantidade": "${saida.quantidade ?? -1}",
      "id_funcionario": "${saida.idFuncionario ?? -1}",
      "motivo": "${saida.motivo}",
    });

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
      case 500:
        throw Erro("Erro do Banco de Dados");
      default:
        throw Erro("Falha de Servidor!");
    }
    return id;
  }

  @override
  Future remover(int id) async {
    var dado = await pegarSaidaDeId(id);
    if (dado == null) {
      throw Erro("Não Existe!");
    }
    var res = await h.post(
      Uri.parse("$URL_REMOVER_SAIDA/${dado.id}/"),
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
  }

  @override
  Future removerAntes(DateTime data) async {
    var res = await pegarLista();
    for (var cada in res) {
      if (cada.data!.isBefore(data)) {
        await remover(cada.id!);
      }
    }
  }

  @override
  Future removerTudo() async {
    var res = await pegarLista();
    for (var cada in res) {
      await remover(cada.id!);
    }
  }
}
