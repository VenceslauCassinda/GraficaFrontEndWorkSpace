import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_pagamento_i.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/forma_pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/fonte_dados/erros.dart';
import 'package:grafica_frontend/fonte_dados/provedores/provedor_pagamento.dart';
import 'package:grafica_frontend/fonte_dados/provedores_net/provedor_net_comprovativo.dart';
import 'package:grafica_frontend/recursos/constantes.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/layouts/layout_campo.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/layouts/layout_forma_selecionar_pagamento.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/painel_gerente_c.dart';

import '../../../../../../dominio/entidades/estado.dart';
import '../../../../../../fonte_dados/provedores_net/provedor_net_pagamento.dart';
import '../../layouts/layout_forma_nova_pagamento.dart';

class PagamentosC extends GetxController {
  RxList<FormaPagamento> lista = RxList<FormaPagamento>();
  late ManipularPagamentoI _manipularPagamentoI;
  PagamentosC() {
    _manipularPagamentoI = ManipularPagamento(ProvedorNetPagamento());
  }
  @override
  void onInit() async {
    await pegarDados();
    super.onInit();
  }

  void terminarSessao() {
    PainelGerenteC c = Get.find();
    c.terminarSessao();
  }

  void mostrarDialogoAdicionarFormaPagamento() {
    mostrarDialogoDeLayou(LayoutNovaFormaPagamento(
        accaoAoFinalizar: (valor, opcao) async {
          var nova = FormaPagamento(
              estado: Estado.ATIVADO, tipo: Pagamento.paraInteiro(opcao??""), forma: valor, descricao: opcao);

          try {
            lista.add(nova);
            voltar();
            nova.id = await _manipularPagamentoI.adicionarFormaPagamento(nova);
          } on Erro catch (e) {
            mostrarDialogoDeInformacao(e.sms);
          }
        },
        titulo: "Insira a nova forma de Pagamento",));
  }

  Future<void> pegarDados() async {
    lista.clear();
    var res = await _manipularPagamentoI.pegarListaFormasPagamento();
    for (var cada in res) {
      lista.add(cada);
    }
  }

  void mostrarDialogoEliminar(FormaPagamento formaPagamento) {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
        pergunta: "Deseja mesmo eliminar esta forma de Pagamento?",
        accaoAoConfirmar: () async {
          try {
            lista.removeWhere((element) => element.id == formaPagamento.id);
            voltar();
            await _manipularPagamentoI.removerFormaDeId(formaPagamento.id!);
          } on Erro catch (e) {
            mostrarDialogoDeInformacao(e.sms);
          }
        },
        accaoAoCancelar: () {},
        corButaoSim: primaryColor));
  }
}
