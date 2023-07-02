import 'dart:convert';

import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_venda_i.dart';
import 'package:grafica_frontend/dominio/entidades/venda.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/solucoes_uteis/utils.dart';
import 'package:http/http.dart' as h;
import '../../recursos/constantes.dart';
import '../../solucoes_uteis/console.dart';
import '../erros.dart';

class ProvedorNetVenda implements ProvedorVendaI {
  @override
  Future<bool> actualizarVenda(Venda venda) async {
    mostrar(venda.dataLevantamentoCompra);
    var res =
        await h.post(Uri.parse("$URL_ATUALIZAR_PEDIDO/${venda.id}/"), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id_funcionario": "${venda.idFuncionario ?? -1}",
      "id_cliente": "${venda.idCliente ?? -1}",
      "parcela": "${venda.parcela}",
      "total": "${venda.total}",
      "data_levantamento": "${venda.dataLevantamentoCompra!}",
      "estado": "${venda.estado ?? 0}",
    });
    mostrar(res.statusCode);
    mostrar(res.body);
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
  Future<int> adicionarVenda(Venda venda) async {
    int id = -1;
    var res = await h.post(Uri.parse(URL_ADD_PEDIDO), headers: {
      "Accept": "aplication/json",
      "Authorization": "Bearer $TOKEN_USUARIO_ATUAL"
    }, body: {
      "id_funcionario": "${venda.idFuncionario ?? -1}",
      "id_cliente": "${venda.idCliente ?? -1}",
      "parcela": "${venda.parcela}",
      "total": "${venda.total}",
      "data_levantamento": "${venda.dataLevantamentoCompra}",
      "estado": "${venda.estado ?? 0}",
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
  Future<List<Venda>> pegarLista(int idUsuario, DateTime data) async {
    var lista = await todas();
    var dados = <Venda>[];
    for (var element in lista) {
      if (element.idFuncionario == -1 || element.idFuncionario == null) {
        dados.add(element);
      } else {
        if ((element.idFuncionario == idUsuario) &&
            comapararDatas(element.data!, data)) {
          dados.add(element);
        }
      }
    }
    return dados;
  }

  @override
  Future<List<Venda>> pegarListaTodasDividas(int idUsuario) async {
    var lista = await todas();
    var dados = <Venda>[];
    for (var element in lista) {
      if ((element.idFuncionario == idUsuario) && (element.divida == true)) {
        dados.add(element);
      }
    }
    return dados;
  }

  @override
  Future<List<Venda>> pegarListaTodasEncomendas(int idUsuario) async {
    var lista = await todas();
    var dados = <Venda>[];
    for (var element in lista) {
      if ((element.idFuncionario == idUsuario) && (element.encomenda == true)) {
        dados.add(element);
      }
    }
    return dados;
  }

  @override
  Future<List<Pagamento>> pegarListaTodasPagamentoDividas(DateTime data) async {
    return <Pagamento>[];
  }

  @override
  Future<List<Pagamento>> pegarListaTodasPagamentoDividasFuncionario(
      int idUsuario, DateTime data) async {
    return <Pagamento>[];
  }

  @override
  Future<List<Venda>> pegarListaTodasVendas() async {
    var lista = await todas();
    var dados = <Venda>[];
    for (var element in lista) {
      if ((element.venda == true)) {
        dados.add(element);
      }
    }
    return dados;
  }

  @override
  Future<List<Venda>> pegarListaVendas() async {
    var lista = await todas();
    var dados = <Venda>[];
    for (var element in lista) {
      if ((element.venda == true)) {
        dados.add(element);
      }
    }
    return dados;
  }

  @override
  Future<List<Venda>> pegarListaVendasFuncionario(int idUsuario) async {
    var lista = await todas();
    var dados = <Venda>[];
    for (var element in lista) {
      if ((element.venda == true) && (element.idFuncionario == idUsuario)) {
        dados.add(element);
      }
    }
    return dados;
  }

  @override
  Future<Venda?> pegarVendaDeId(int id) async {
    var lista = await todas();
    return lista.firstWhereOrNull((element) => element.id == id);
  }

  @override
  Future<int> removerTodas() async {
    var res = await todas();
    for (var cada in res) {
      await removerVendaDeId(cada.id!);
    }
    return 1;
  }

  @override
  Future<int> removerVendaDeId(int id) async {
    var res = await h.post(
      Uri.parse("$URL_REMOVER_PEDIDO/$id/"),
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
    return id;
  }

  @override
  Future<List<Venda>> todas() async {
    var lista = <Venda>[];
    var res = await h.get(
      Uri.parse(URL_TODOS_PEDIDO),
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
            lista.add(Venda.fromJson(cada));
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
  Future<List<Venda>> todasDividas() async {
    var lista = await todas();
    var dados = <Venda>[];
    for (var element in lista) {
      if ((element.divida == true)) {
        dados.add(element);
      }
    }
    return dados;
  }
}
