import 'dart:async';

import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:grafica_frontend/dominio/entidades/comprovativo.dart';
import 'package:grafica_frontend/dominio/entidades/cores.dart';
import 'package:grafica_frontend/dominio/entidades/detalhe_item.dart';
import 'package:grafica_frontend/dominio/entidades/estado.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/dominio/entidades/item_venda.dart';
import 'package:grafica_frontend/dominio/entidades/nivel_acesso.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';
import 'package:grafica_frontend/dominio/entidades/venda.dart';
import 'package:grafica_frontend/fonte_dados/erros.dart';
import 'package:grafica_frontend/fonte_dados/provedores_net/provedor_net_detalhe_item.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/solucoes_uteis/geradores.dart';

import '../../../../../../../../../contratos/casos_uso/manipular_pagamento_i.dart';
import '../../../../../../../../../dominio/casos_uso/manipular_cliente.dart';
import '../../../../../../../../../dominio/casos_uso/manipular_pagamento.dart';
import '../../../../../../../../../dominio/casos_uso/manipular_venda.dart';
import '../../../../../../../../../dominio/entidades/forma_pagamento.dart';
import '../../../../../../../../../dominio/entidades/preco.dart';
import '../../../../../../../../../dominio/entidades/stock.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_comprovativo.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_cliente.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_funcionario.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_item_venda.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_pagamento.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_preco.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_produto.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_saida.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_stock.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_usuario.dart';
import '../../../../../../../../../fonte_dados/provedores_net/provedor_net_venda.dart';
import '../../../../../../../../aplicacao_c.dart';
import '../../layout_detalhe_tshirt.dart';
import '../../layout_forma_selecionar_pagamento.dart';
import '../../vendas_c.dart';

class MesaVendaC extends GetxController {
  RxList<Pagamento> listaPagamentos = <Pagamento>[].obs;
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
  RxList<ItemVenda> listaItensVenda = <ItemVenda>[].obs;

  MesaVendaC(this.data, this.funcionario) {
    _manipularClienteI = ManipularCliente(ProvedorNetCliente());
    _manipularStockI = ManipularStock(ProvedorNetStock());
    _manipularPagamentoI = ManipularPagamento(ProvedorNetPagamento(),
        provedorComprovativoI: ProvedorNetComprovativo());
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

  @override
  void onInit() async {
    super.onInit();
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
            future: pegarAplicacaoC().pegarUsuarioActual()!.nivelAcesso! == NivelAcesso.CLIENTE ? _manipularPagamentoI.pegarListaFormasPagamentoCliente(): _manipularPagamentoI.pegarListaFormasPagamento(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Nenhuma Forma de Pagamento À Prazo!"),
                );
              }
              var lista = snapshot.data!.map((e) => e.forma!).toList();
              return LayoutSelecionarFormaPagamento(
                  accaoAoFinalizar: (valor, opcao, arquivo) async {
                    try {
                      await adicionarValorPagamento(valor, opcao, arquivo);
                    } on Erro catch (e) {
                      mostrarDialogoDeInformacao(e.sms);
                    }
                  },
                  titulo: "Selecione a Forma de Pagamento",
                  listaItens: lista);
            }),
        naoFechar: true);
  }

  Future<void> adicionarValorPagamento(
      String valor, String? opcao, PlatformFile arquivo) async {
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
        valor: double.parse(valor),
        comprovativo:
            Comprovativo(descricao: "Pagamento de Cliente", arquivo: arquivo)));
    voltar();
  }

  void adicionarProdutoAmesa(Produto produto) {
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
              DateTime(dataActual.year, dataActual.month, dataActual.day + 2),
          firstDate:
              DateTime(dataActual.year, dataActual.month, dataActual.day + 2),
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
          "Coloque alguma quantidade dos produtos adicionados!");
      return;
    }
    if (pago < aPagar / 2) {
      mostrarDialogoDeInformacao(
          "Deve pagar 50% ou mais para finalizar a venda!");
      return;
    }
    mostrarCarregandoDialogoDeInformacao("Finalizando a Venda");
    dataLevantamento.value ??= data.add(Duration(days: 1));
    var cliente = (await _manipularClienteI.pegarClienteDeUsuarioDeId(
                  pegarAplicacaoC().pegarUsuarioActual()!.id!));
                  // mostrar2(cliente!.toJson());
    try {
      var venda = Venda(
          produto: null,
          idProduto: null,
          itensVenda: listaItensVenda,
          quantidadeVendida: null,
          pagamentos: listaPagamentos,
          estado: Venda.ESPERA,
          idFuncionario: -1,
          idCliente: cliente!.id!,
          data: data,
          dataLevantamentoCompra: dataLevantamento.value,
          total: aPagar,
          parcela: pago);

      var id = await _manipularVendaI.vender(
          listaItensVenda,
          listaPagamentos,
          aPagar,
          -1,
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

  void mostrarDialogoProdutos(BuildContext context) {}

  Future<Comprovativo?> pegarComprovativoDoPagamentoDeId(int id) async {
    var c = await _manipularPagamentoI.pegarComprovativoDoPagamentoDeId(id);
    return c;
  }

  personalisar(ItemVenda itemVenda, BuildContext context) {
    var corTshirt = Cores.paraColor(itemVenda.produto!.nome!);;
    var corCampoTexto = corTshirt ==Colors.white ? Colors.black.obs : Colors.white.obs;

    mostrarDialogoDeLayou(
        LayoutDetalheTshirt(corCampoTexto: corCampoTexto, corProduto: corTshirt,itemVenda: itemVenda, c: this,permissao: true,),
        layoutCru: true);
  }
  
  
  void salvarDetalhe(ItemVenda itemVenda, List<DetalheItem> lista) {
    for (var i = 0; i < listaItensVenda.length; i++) {
      if(listaItensVenda[i].idVista == itemVenda.idVista){
        listaItensVenda[i] == itemVenda;
        listaItensVenda[i].detalhes = lista;
      }
    }
  }
}

