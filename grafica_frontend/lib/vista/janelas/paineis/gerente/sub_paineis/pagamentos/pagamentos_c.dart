import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_pagamento_i.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/forma_pagamento.dart';
import 'package:grafica_frontend/fonte_dados/provedores/provedor_pagamento.dart';
import 'package:grafica_frontend/recursos/constantes.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/layouts/layout_campo.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/layouts/layout_forma_pagamento.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/painel_gerente_c.dart';

import '../../../../../../dominio/entidades/estado.dart';
import '../../../../../../fonte_dados/provedores_net/povedor_net_pagamento.dart';

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
    mostrarDialogoDeLayou(LayoutCampo(
        accaoAoFinalizar: (valor) async {
          var nova =
              FormaPagamento(estado: Estado.ATIVADO, tipo: "0", descricao: valor);

          lista.add(nova);
          voltar();
          nova.id = await _manipularPagamentoI.adicionarFormaPagamento(nova);
        },
        titulo: "Insira a nova forma de Pagamento"));
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
          lista.removeWhere((element) => element.id == formaPagamento.id);
          voltar();
          await _manipularPagamentoI.removerFormaDeId(formaPagamento.id!);
        },
        accaoAoCancelar: () {},
        corButaoSim: primaryColor));
  }
}
