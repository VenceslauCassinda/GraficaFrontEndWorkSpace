import 'dart:async';
import 'package:componentes_visuais/componentes/observadores/observador_butoes.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_cliente.dart';
import 'package:grafica_frontend/dominio/entidades/nivel_acesso.dart';
import 'package:grafica_frontend/fonte_dados/provedores_net/provedor_net_cliente.dart';
import 'package:grafica_frontend/vista/componentes/item_usuario.dart';
import 'package:grafica_frontend/vista/janelas/cadastro/janela_cadastro.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_fincionario.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_usuario.dart';
import 'package:grafica_frontend/dominio/entidades/estado.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/fonte_dados/provedores/provedor_funcionario.dart';
import 'package:grafica_frontend/fonte_dados/provedores/provedores_usuario.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/dinheiro_sobra/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/saida_caixa/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/vendas/layouts/vendas_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/clientes/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/desperdicio/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/entradas/layouts/entradas_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/resumo/resumo_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/inventario/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/investimento/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/pagamentos/pagamentos_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/perfil/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/produtos/layouts/produtos_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/relatorio/painel_c.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/saidas/layouts/saidas_c.dart';
import '../../../../contratos/casos_uso/manipular_funcionario_i.dart';
import '../../../../dominio/entidades/painel_actual.dart';
import '../../../../fonte_dados/provedores_net/provedor_net_funcionario.dart';
import '../../../../fonte_dados/provedores_net/provedor_net_usuario.dart';
import '../../../aplicacao_c.dart';
import '../../../componentes/item_funcionario.dart';
import '../../cadastro/janela_cadastro_c.dart';
import '../funcionario/sub_paineis/dividas_encomendas_gerais/painel_c.dart';
import 'sub_paineis/servicos/painel_c.dart';

class PainelGerenteC extends GetxController {
  var painelActual =
      PainelActual(indicadorPainel: PainelActual.NENHUM, valor: null).obs;
  var lista = RxList<Funcionario>();
  var listaCopia = <Funcionario>[];
  var dadoPesquisado = "".obs;
  late Funcionario funcionarioActual;
  var baixando = false.obs;

  var listaControladores = <Type>[];

  late ManipularFuncionarioI _manipularFuncionarioI;
  PainelGerenteC() {
    _manipularFuncionarioI = ManipularFuncionario(
        ManipularUsuario(ProvedorNetUsuario()), ProvedorNetFuncionario());
  }

  @override
  void onInit() async {
    await inicializarFuncionario();
    await pegarTodos();
    super.onInit();
  }

  Future<Funcionario> inicializarFuncionario() async {
    return funcionarioActual =
        await _manipularFuncionarioI.pegarFuncionarioDoUsuarioDeId(
            (pegarAplicacaoC().pegarUsuarioActual())!.id!);
  }

  Future<void> mudarEstadoFuncionario(Funcionario funcionario) async {
    for (var i = 0; i < lista.length; i++) {
      if (funcionario.nomeUsuario == lista[i].nomeUsuario) {
        if (funcionario.estado == Estado.DESACTIVADO) {
          await _manipularFuncionarioI.activarFuncionario(funcionario);
          funcionario.estado = Estado.ATIVADO;
          lista[i] = funcionario;
        } else {
          await _manipularFuncionarioI.desactivarFuncionario(funcionario);
          funcionario.estado = Estado.DESACTIVADO;
          lista[i] = funcionario;
        }
        break;
      }
    }
  }

  Future<void> navegar(int tab) async {
    if (tab == 0) {
      await pegarTodos();
    }
    if (tab == 1) {
      await pegarActivos();
    }
    if (tab == 2) {
      await pegarDesactivos();
    }
  }

  void irParaPainel(int indicadorPainel, {valor}) async {
    painelActual.value =
        PainelActual(indicadorPainel: indicadorPainel, valor: valor);
    if (painelActual.value.indicadorPainel == PainelActual.PRODUTOS) {
      Get.delete<ProdutosC>();
    }
    if (PainelActual.VENDAS_FUNCIONARIOS ==
            painelActual.value.indicadorPainel ||
        PainelActual.VENDAS_ANTIGA == indicadorPainel) {
      Get.delete<VendasC>();
      Get.delete<PainelResumoC>();
    }
    if (PainelActual.VENDAS == painelActual.value.indicadorPainel ||
        PainelActual.VENDAS_ANTIGA == indicadorPainel) {
      Get.delete<PainelResumoC>();
    }
    if (PainelActual.SAIDA_CAIXA == painelActual.value.indicadorPainel) {
      Get.delete<PainelSaidaCaixaC>();
    }
    if (PainelActual.DINHEIRO_SOBRA == painelActual.value.indicadorPainel) {
      Get.delete<PainelDinheiroSobraC>();
    }
    if (PainelActual.INVESTIMENTO == painelActual.value.indicadorPainel) {
      Get.delete<PainelInvestimentoC>();
    }
    if (PainelActual.RELATORIO == painelActual.value.indicadorPainel) {
      Get.delete<PainelRelatorioC>();
    }
    if (PainelActual.DESPERDICIOS == painelActual.value.indicadorPainel) {
      Get.delete<PainelDesperdicioC>();
    }
    if (PainelActual.PERFIL == painelActual.value.indicadorPainel) {
      Get.delete<PainelPerfilC>();
    }
    if (PainelActual.DIVIDAS_GERAIS == painelActual.value.indicadorPainel) {
      Get.delete<PainelDividasC>();
    }
    if (PainelActual.SAIDAS_GERAL == painelActual.value.indicadorPainel) {
      Get.delete<SaidasC>();
    }
    if (PainelActual.SAIDAS == painelActual.value.indicadorPainel) {
      Get.delete<SaidasC>();
    }
    if (PainelActual.ENTRADAS == painelActual.value.indicadorPainel) {
      Get.delete<EntradasC>();
    }
    if (PainelActual.ENTRADAS_GERAL == painelActual.value.indicadorPainel) {
      Get.delete<EntradasC>();
    }
    if (PainelActual.PAGAMENTOS == painelActual.value.indicadorPainel) {
      Get.delete<PagamentosC>();
    }
    if (PainelActual.DEFINICOES == painelActual.value.indicadorPainel) {
      Get.delete<PagamentosC>();
    }
    if (PainelActual.CLIENTES == painelActual.value.indicadorPainel) {
      Get.delete<PainelClientesC>();
    }
    if (PainelActual.INVENTARIO == painelActual.value.indicadorPainel) {
      Get.delete<PainelInventarioC>();
    }if (PainelActual.SERVICOS == painelActual.value.indicadorPainel) {
      Get.delete<ServicosC>();
    }

    ScreenSize tela = Get.find();
    if (tela.tablet != null || tela.mobile != null) {
      voltar();
    }
  }

  Future<void> pegarTodos() async {
    listaCopia.clear();
    lista.clear();
    baixando.value = true;
    for (var cada in (await _manipularFuncionarioI.pegarLista())) {
      if (cada.nivelAcesso != null) {
        if (cada.nivelAcesso != NivelAcesso.GERENTE) {
          lista.add(cada);
        }
      }else{
        if (cada.usuario?.nivelAcesso != null && cada.usuario?.nivelAcesso != NivelAcesso.GERENTE) {
          lista.add(cada);
        }
      }
    }
    baixando.value = false;
    listaCopia.addAll(lista);
  }

  Future<void> pegarActivos() async {
    lista.clear();
    for (var cada in (await _manipularFuncionarioI.pegarLista())) {
      if (cada.estado == Estado.ATIVADO) {
        lista.add(cada);
      }
    }
  }

  Future<void> pegarDesactivos() async {
    lista.clear();
    for (var cada in (await _manipularFuncionarioI.pegarLista())) {
      if (cada.estado == Estado.DESACTIVADO) {
        lista.add(cada);
      }
    }
  }

  void terminarSessao() {
    AplicacaoC.terminarSessao();
  }

  void escolherDataVerVenda(
      BuildContext context, Funcionario funcionario) async {
    var hoje = DateTime.now();
    var dataSelecionada = await showDatePicker(
        context: context,
        initialDate: hoje,
        firstDate: hoje.subtract(Duration(days: 365 * 3)),
        lastDate: hoje);
    if (dataSelecionada == null) {
      return;
    }
    irParaPainel(PainelActual.VENDAS_FUNCIONARIOS,
        valor: [funcionario, dataSelecionada]);
  }

  void aoPesquisar(String dado) async {
    lista.clear();
    for (var cada in listaCopia) {
      if ((cada.nomeUsuario ?? "").toLowerCase().contains(dado.toLowerCase())) {
        lista.add(cada);
      }
    }
  }

  void mostrarDialogoAdicionarFuncionario(BuildContext context) async {
    late ValidacaoCampos validacaoCampos = ValidacaoCampos();
    late ObservadorButoes observadorButoes = ObservadorButoes();

    var nome = "".obs, palavraPasse = "".obs, confirmePalavraPasse = "".obs;
    var manipularUsuario = ManipularUsuario(ProvedorNetUsuario());
    var usuarios = await manipularUsuario.pegarLista();

    var janelaCadastroC = JanelaCadastroC();
    janelaCadastroC.modoRegitroCliente = false;

    mostrarDialogoDeLayou(Container(
      width: MediaQuery.of(context).size.width * .6,
      child: LayoutCadastro(
        c: janelaCadastroC,
        confirmePalavraPasse: confirmePalavraPasse,
        nome: nome,
        observadorButoes: observadorButoes,
        palavraPasse: palavraPasse,
        validacaoCampos: validacaoCampos,
        aoFinalizar: (novoFuncionario) {
          lista.add(novoFuncionario);
        },
      ),
    ));
  }
}

PainelGerenteC pegarPainelGerenteC() {
  return Get.find();
}
