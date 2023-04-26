import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_funcionario_i.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_fincionario.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_usuario.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/vista/aplicacao_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/dinheiro_sobra/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/dividas_encomendas_gerais/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/historico/historico_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/saida_caixa/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/vendas/layouts/vendas_c.dart';
import '../../../../dominio/entidades/painel_actual.dart';
import '../../../../fonte_dados/provedores_net/provedor_net_funcionario.dart';
import '../../../../fonte_dados/provedores_net/provedor_net_usuario.dart';
import '../gerente/sub_paineis/clientes/painel_c.dart';

class PainelFuncionarioC extends GetxController {
  var painelActual = PainelActual(indicadorPainel: PainelActual.NENHUM, valor: null).obs;
  late DateTime data;
  Funcionario? funcionarioActual;
  late ManipularFuncionarioI _manipularFuncionarioI;
  PainelFuncionarioC() {
    data = DateTime.now();
    _manipularFuncionarioI = ManipularFuncionario(
        ManipularUsuario(ProvedorNetUsuario()), ProvedorNetFuncionario());
  }

  @override
  void onInit() async {
    await inicializarFuncionario();
    super.onInit();
  }

  Future<Funcionario> inicializarFuncionario() async {
    funcionarioActual =
        await _manipularFuncionarioI.pegarFuncionarioDoUsuarioDeId(
            (pegarAplicacaoC().pegarUsuarioActual())!.id!);
            return funcionarioActual!;
  }

  void terminarSessao() {
    Get.delete<HistoricoC>();
    Get.delete<VendasC>();
    AplicacaoC.terminarSessao();
  }

  void navegar(int indice) {}

  void irParaPainel(int indice, {Object? valor}) {
    if (PainelActual.VENDAS_ANTIGA == indice) {
      Get.delete<VendasC>();
    }
    if (PainelActual.INICIO != painelActual.value.indicadorPainel &&
        PainelActual.INICIO == indice) {
      Get.delete<VendasC>();
    }
    if (PainelActual.DIVIDAS_GERAIS == painelActual.value.indicadorPainel) {
      Get.delete<PainelDividasC>();
    }
    if (PainelActual.DINHEIRO_SOBRA == painelActual.value.indicadorPainel) {
      Get.delete<PainelDinheiroSobraC>();
    }
    if (PainelActual.SAIDA_CAIXA == painelActual.value.indicadorPainel) {
      Get.delete<PainelSaidaCaixaC>();
    }
    if (PainelActual.CLIENTES == painelActual.value.indicadorPainel) {
      Get.delete<PainelClientesC>();
    }
    if (PainelActual.VENDAS_FUNCIONARIOS ==
        painelActual.value.indicadorPainel) {
      Get.delete<VendasC>();
    }
    painelActual.value = PainelActual(indicadorPainel: indice, valor: valor);

      voltar(); 
    // ScreenSize tela = Get.find();
    // if (tela.tablet != null||tela.mobile != null) {
    //   voltar();
    // }
  }
}
