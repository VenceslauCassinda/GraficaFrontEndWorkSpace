import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_servicos_i.dart';
import 'package:grafica_frontend/dominio/entidades/detalhe_item.dart';
import 'package:grafica_frontend/fonte_dados/provedores_net/provedor_net_tema.dart';
import 'package:grafica_frontend/recursos/constantes.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/layouts/layout_add_servico.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/painel_gerente_c.dart';

import '../../../../../../dominio/casos_uso/manipular_servicos.dart';
import '../../../../../../dominio/entidades/tipo_detalhe.dart';
import '../../../../../../dominio/entidades/evento.dart';
import '../../../../../../dominio/entidades/servico.dart';
import '../../../../../../dominio/entidades/tema.dart';
import '../../../../../../fonte_dados/provedores_net/provedor_net_detalhe_item.dart';
import '../../../../../../fonte_dados/provedores_net/provedor_net_evento.dart';
import '../../../../../../fonte_dados/provedores_net/provedor_net_servico.dart';
import '../../layouts/layout_add_detalhe.dart';
import '../../layouts/layout_campo.dart';

class ServicosC extends GetxController {
  Rx<List<Servico>?> servicos = Rx(null);
  Rx<List<TipoDetalhe>?> detalhes = Rx(null);
  Rx<List<Tema>?> temas = Rx(null);
  Rx<List<Evento>?> eventos = Rx(null);
  var indiceTab = 0.obs;
  late ManipularServicosI _manipularServicosI;
  ServicosC() {
      _manipularServicosI = ManipularServicos(ProvedorNetServico(), ProvedorNetTema(), ProvedorNetEvento(), ProvedorNetDetalheItem());
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

  void mostrarDialogoAdicionarFormaServico() {
    mostrarDialogoDeLayou(LayoutAddServico(
      accaoAoFinalizar: (nome, tipo) async {
        var novo = Servico(
            descricao: "Disponibilidade de Serviço", servico: nome, tipo: tipo);
        servicos.value!.add(novo);
        voltar();
        await _manipularServicosI.registarServico(novo);
      },
    ));
  }
  
  void mostrarDialogoAdicionarDetalhe() {
    mostrarDialogoDeLayou(LayoutAddDetalhe(
      accaoAoFinalizar: (nome, tipo, tipoProduto) async {
        var novo = TipoDetalhe(
          detalhe: nome, tipo: tipo, tipoProduto: tipoProduto);
        detalhes.value!.add(novo);
        voltar();
        await _manipularServicosI.registarTipoDetalhe(novo);
      },
    ));
  }

  void mostrarDialogoAdicionarTema() {
    mostrarDialogoDeLayou(LayoutCampo(
      accaoAoFinalizar: (nome) async {
        var novo = Tema(
          descricao: "Tema para embelezamento de Produtos",
          tema: nome,
        );
        temas.value!.add(novo);
        voltar();
        await _manipularServicosI.registarTema(novo);
      },
      titulo: "DADOS DO TEMA",
      dicaParaCampo: "Nome do Tema",
    ));
  }
  
  void mostrarDialogoAdicionarEvento() {
    mostrarDialogoDeLayou(LayoutCampo(
      accaoAoFinalizar: (nome) async {
        var novo = Evento(
          descricao: "Evento em que será usado o Produtos",
          evento: nome,
        );
        eventos.value!.add(novo);
        voltar();
        await _manipularServicosI.registarEvento(novo);
      },
      titulo: "DADOS DO EVENTO",
      dicaParaCampo: "Nome do Evento",
    ));
  }

  void mostrarDialogoRemoverServico(Servico dado) {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
        pergunta: "Deseja mesmo eliminar?",
        accaoAoConfirmar: () async{
          servicos.value!.removeWhere((element) => element.id == dado.id);
          voltar();
          await _manipularServicosI.removerServico(dado.id!);
        },
        accaoAoCancelar: () {},
        corButaoSim: primaryColor));
  }
  
  void mostrarDialogoRemoverTema(Tema dado) {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
        pergunta: "Deseja mesmo eliminar?",
        accaoAoConfirmar: () async{
          temas.value!.removeWhere((element) => element.id == dado.id);
          voltar();
          await _manipularServicosI.removerTema(dado.id!);
        },
        accaoAoCancelar: () {},
        corButaoSim: primaryColor));
  }
  
  void mostrarDialogoRemoverEvento(Evento dado) {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
        pergunta: "Deseja mesmo eliminar?",
        accaoAoConfirmar: () async{
          eventos.value!.removeWhere((element) => element.id == dado.id);
          voltar();
          await _manipularServicosI.removerEvento(dado.id!);
        },
        accaoAoCancelar: () {},
        corButaoSim: primaryColor));
  }
  
  void mostrarDialogoRemoverDetalhe(TipoDetalhe dado) {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
        pergunta: "Deseja mesmo eliminar?",
        accaoAoConfirmar: () async{
          detalhes.value!.removeWhere((element) => element.id == dado.id);
          voltar();
          await _manipularServicosI.removerTipoDetalhe(dado.id!);
        },
        accaoAoCancelar: () {},
        corButaoSim: primaryColor));
  }

  Future<void> pegarDados() async {
    var res = await _manipularServicosI.pegarListaServico();
    servicos.value = RxList([]);
    for (var cada in res) {
      servicos.value!.add(cada);
    }
    var res1 = await _manipularServicosI.pegarListaTema();
    temas.value = RxList([]);
    for (var cada in res1) {
      temas.value!.add(cada);
    }
    
    var res2 = await _manipularServicosI.pegarListaEvento();
    eventos.value = RxList([]);
    for (var cada in res2) {
      eventos.value!.add(cada);
    }
    
    var res3 = await _manipularServicosI.pegarListaTipoDetalhe();
    detalhes.value = RxList([]);
    for (var cada in res3) {
      detalhes.value!.add(cada);
    }
  }

  // void mostrarDialogoEliminar(FormaServico formaServico) {
  //   mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
  //       pergunta: "Deseja mesmo eliminar esta forma de Servico?",
  //       accaoAoConfirmar: () async {
  //         try {
  //           lista.removeWhere((element) => element.id == formaServico.id);
  //           voltar();
  //           await _manipularServicoI.removerFormaDeId(formaServico.id!);
  //         } on Erro catch (e) {
  //           mostrarDialogoDeInformacao(e.sms);
  //         }
  //       },
  //       accaoAoCancelar: () {},
  //       corButaoSim: primaryColor));
  // }
}
