import 'dart:async';

import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_cliente_I.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_funcionario_i.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_item_venda_i.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_stock_i.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_venda_i.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipula_stock.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_fincionario.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_item_venda.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_preco.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_produto.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_saida.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_usuario.dart';
import 'package:grafica_frontend/dominio/entidades/cliente.dart';
import 'package:grafica_frontend/dominio/entidades/estado.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/dominio/entidades/item_venda.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';
import 'package:grafica_frontend/dominio/entidades/venda.dart';
import 'package:grafica_frontend/fonte_dados/erros.dart';
import 'package:grafica_frontend/solucoes_uteis/geradores.dart';
import 'package:grafica_frontend/vista/aplicacao_c.dart';

import '../../../../../../../../../contratos/casos_uso/manipular_pagamento_i.dart';
import '../../../../../../../../../dominio/casos_uso/manipular_cliente.dart';
import '../../../../../../../../../dominio/casos_uso/manipular_pagamento.dart';
import '../../../../../../../../../dominio/casos_uso/manipular_venda.dart';
import '../../../../../../../../../dominio/entidades/forma_pagamento.dart';
import '../../../../../../../../../dominio/entidades/preco.dart';
import '../../../../../../../../../dominio/entidades/stock.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_cliente.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_comprovativo.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_detalhe_item.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_funcionario.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_item_venda.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_pagamento.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_preco.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_produto.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_saida.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_stock.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_usuario.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_venda.dart';
import '../../../../../../gerente/layouts/layout_forma_pagamento.dart';
import '../../vendas_c.dart';

class MesaVendaC extends GetxController {
  RxList<Pagamento> listaPagamentos = <Pagamento>[].obs;
  RxList<ItemVenda> listaItensVenda = <ItemVenda>[].obs;
  RxList<bool> hojeOuData = RxList([true, false]);
  Rx<DateTime?> dataLevantamento = Rx(null);

  late ManipularPagamentoI _manipularPagamentoI;
  late ManipularItemVendaI _manipularItemVendaI;
  late ManipularVendaI _manipularVendaI;
  late ManipularStockI _manipularStockI;
  late ManipularClienteI _manipularClienteI;
  late ManipularFuncionarioI _manipularFuncionarioI;
  final Funcionario funcionario;
  final DateTime data;
  var nomeCliente = "".obs;
  var telefoneCliente = "".obs;

  MesaVendaC(this.data, this.funcionario) {
    _manipularClienteI = ManipularCliente(ProvedorNetCliente());
    _manipularStockI = ManipularStock(ProvedorNetStock());
    _manipularPagamentoI = ManipularPagamento(ProvedorNetPagamento());
    _manipularItemVendaI = ManipularItemVenda(
        ProvedorNetItemVenda(),
        ManipularProduto(ProvedorNetProduto(), _manipularStockI,
            ManipularPreco(ProvedorNetPreco())),
        ManipularStock(ProvedorNetStock()), ProvedorNetDetalheItem());
    _manipularVendaI = ManipularVenda(
        ProvedorNetVenda(),
        ManipularSaida(ProvedorNetSaida(), _manipularStockI),
        _manipularPagamentoI,
        _manipularClienteI,
        _manipularStockI,
        _manipularItemVendaI);
    _manipularFuncionarioI = ManipularFuncionario(
        ManipularUsuario(ProvedorNetUsuario()), ProvedorNetFuncionario());
  }

  void mostrarFormasPagamento(BuildContext context) {
    var aPagar = listaItensVenda.fold<double>(
        0, (previousValue, element) => ((element.total ?? 0) + previousValue));
    if (aPagar == 0) {
      mostrarSnack("Nenhum produto com quantidade pagável!");
      return;
    }
    var pago = listaPagamentos.fold<double>(
        0, (previousValue, element) => ((element.valor ?? 0) + previousValue));
    if (pago == aPagar) {
      mostrarSnack("Está tudo pago!");
      return;
    }
    mostrarDialogoDeLayou(
        FutureBuilder<List<FormaPagamento>>(
            future: _manipularPagamentoI.pegarListaFormasPagamento(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Nenhuma Forma de Pagamento!"),
                );
              }
              var lista = snapshot.data!.map((e) => e.descricao!).toList();
              return LayoutFormaPagamento(
                  accaoAoFinalizar: (valor, opcao) async {
                    await adicionarValorPagamento(valor, opcao);
                  },
                  titulo: "Selecione a Forma de Pagamento",
                  listaItens: lista);
            }),
        naoFechar: true);
  }

  Future<void> adicionarValorPagamento(String valor, String? opcao) async {
    var soma = listaPagamentos.fold<double>(
        0, (previousValue, element) => element.valor! + previousValue);

    var totalApagar =
        await _manipularItemVendaI.calcularTotalApagar(listaItensVenda);
    if ((soma + double.parse(valor)) > totalApagar) {
      mostrarDialogoDeInformacao("""Valor demasiado alto!""");
      return;
    }
    var forma = (await _manipularPagamentoI.pegarListaFormasPagamento())
        .firstWhere((element) => element.descricao == opcao);
    listaPagamentos.add(Pagamento(
        idParaVista: gerarIdUnico(),
        idFormaPagamento: forma.id,
        formaPagamento: forma,
        estado: Estado.ATIVADO,
        valor: double.parse(valor)));
    voltar();
  }

  void adicionarProdutoAmesa(Produto produto) {
    var teste = listaItensVenda
        .firstWhereOrNull((element) => element.idProduto == produto.id);
    if (teste != null) {
      mostrarDialogoDeInformacao("Este produto já foi adicionado!",
          naoFechar: true);
      return;
    }
    listaItensVenda.add(ItemVenda(
        idVista: gerarIdUnico(),
        estado: Estado.ATIVADO,
        idProduto: produto.id,
        produto: produto,
        quantidade: 0,
        desconto: 0));
  }

  void definirQuantidade(
      int valor,
      ItemVenda element,
      TextEditingController campoTextoQuantidadeC,
      TextEditingController campoTextoDescontoC) {
    // if (element.produto!.listaPreco!.isEmpty) {
    //   mostrarDialogoDeInformacao("Produto sem preço!");
    //   return;
    // }
    if (element.produto!.stock!.quantidade! < valor) {
      int quantidadeDisponivel = int.parse(campoTextoQuantidadeC.text) +
          (element.produto!.stock!.quantidade! - valor);
      campoTextoQuantidadeC.text = quantidadeDisponivel.toString();
      mostrarDialogoDeInformacao(
          "Produto com quantidade insuficiente em Stock!");
      valor = quantidadeDisponivel;
    }
    element.quantidade = valor;
    element.total = valor * element.produto!.precoGeral;

    descontar(
        int.tryParse(campoTextoDescontoC.text), element, campoTextoDescontoC);
  }

  void atualizarItemVenda(ItemVenda element) {
    for (var i = 0; i < listaItensVenda.length; i++) {
      if (listaItensVenda[i].idProduto == element.idProduto) {
        listaItensVenda[i] = element;
        break;
      }
    }
  }

  void descontar(int? valor, ItemVenda element,
      TextEditingController campoTextoDescontoC) async {
    valor ??= 0;
    if ((valor < 0) || (valor > 100)) {
      mostrarDialogoDeInformacao("Desconto inválido!");
      campoTextoDescontoC.clear();
      return;
    }
    if (element.total == null) {
      mostrarDialogoDeInformacao("Por favor! Defina a quantidade!");
      campoTextoDescontoC.clear();
      return;
    }
    if (element.total == 0) {
      // element.total = element.quantidade! * element.produto!.listaPreco![0];
    }

    element.desconto = valor;

    // element.total = _manipularItemVendaI.aplicarDescontoVenda(
    //     element.quantidade! * element.produto!.listaPreco![0], valor);
    atualizarItemVenda(element);
  }

  void removerPagamento(Pagamento pagamento) {
    listaPagamentos.removeWhere((element) {
      return element.idParaVista == pagamento.idParaVista;
    });
  }

  void removerItemVenda(ItemVenda itemVenda) {
    listaItensVenda.removeWhere((element) {
      return element.idVista == itemVenda.idVista;
    });
  }

  int contadorSeleccoesData = 0;
  void mudarData(int i, BuildContext context) async {
    hojeOuData[i] = !hojeOuData[i];
    for (var a = 0; a < hojeOuData.length; a++) {
      if (i != a) {
        hojeOuData[a] = !hojeOuData[a];
      }
    }
    var dataActual = data;

    if (i == 1) {
      var dataSelecionada = await showDatePicker(
          context: context,
          initialDate:
              DateTime(dataActual.year, dataActual.month, dataActual.day + 1),
          firstDate:
              DateTime(dataActual.year, dataActual.month, dataActual.day + 1),
          lastDate: DateTime(2100));
      var momento = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(dataActual));
      if (dataSelecionada != null && momento != null) {
        dataLevantamento.value = DateTime(
          dataSelecionada.year,
          dataSelecionada.month,
          dataSelecionada.day,
          momento.hour,
          momento.minute,
        );
      } else {
        hojeOuData[0] = !hojeOuData[0];
        hojeOuData[1] = !hojeOuData[1];
      }
    } else {
      dataLevantamento.value = null;
    }
  }

  void vender(VendasC vendasC) async {
    if (nomeCliente.value.isEmpty) {
      mostrarDialogoDeInformacao("Insira o nome do Cliente!");
      return;
    }
    if (telefoneCliente.value.isEmpty) {
      mostrarDialogoDeInformacao("Insira o contacto do Cliente!");
      return;
    }

    var aPagar = listaItensVenda.fold<double>(
        0, (previousValue, element) => ((element.total ?? 0) + previousValue));
    var pago = listaPagamentos.fold<double>(
        0, (previousValue, element) => ((element.valor ?? 0) + previousValue));
    if (aPagar == 0) {
      if (listaItensVenda.isEmpty) {
        mostrarDialogoDeInformacao("Adicione produtos!");
        return;
      }
      mostrarDialogoDeInformacao(
          "Venda alguma quantidade dos produtos adicionados!");
      return;
    }
    mostrarCarregandoDialogoDeInformacao("Finalizando a Venda");
    dataLevantamento.value ??= data;
    try {
      var cliente = Cliente(
          estado: Estado.ATIVADO,
          nome: nomeCliente.value,
          numero: telefoneCliente.value);
      var venda = Venda(
          produto: null,
          idProduto: null,
          itensVenda: listaItensVenda,
          quantidadeVendida: null,
          pagamentos: listaPagamentos,
          estado: Estado.ATIVADO,
          idFuncionario: funcionario.id!,
          idCliente: -1,
          data: data,
          dataLevantamentoCompra: dataLevantamento.value,
          total: aPagar,
          cliente: cliente,
          parcela: pago);

      var id = await _manipularVendaI.vender(
          listaItensVenda,
          listaPagamentos,
          aPagar,
          funcionario.id!,
          cliente,
          data,
          dataLevantamento.value!,
          pago,
          -1,
          0);
      venda.id = id;
      vendasC.lista.insert(0, venda);
      vendasC.totalCaixa.value += pago;
      voltar();
      // vendasC.navegar(vendasC.indiceTabActual);
    } on Erro catch (e) {
      mostrarDialogoDeInformacao(e.sms);
    }
  }

  Future<Stock?> pegarStockDoProdutoDeId(int id) async {
    return await _manipularStockI.pegarStockDoProdutoDeId(id);
  }

  Future<List<Preco>> pegarPrecoDoProdutoDeId(int id) async {
    return await ProvedorNetPreco().pegarPrecoProdutoDeId(id);
  }
}
