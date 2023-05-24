import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/vista/janelas/paineis/cliente/painel_cliente.dart';
import '../dominio/casos_uso/manipular_definicoes.dart';
import '../dominio/casos_uso/manipular_usuario.dart';
import '../dominio/entidades/nivel_acesso.dart';
import '../dominio/entidades/usuario.dart';
import '../fonte_dados/provedores/provedores_usuario.dart';
import '../fonte_dados/provedores_net/provedor_net_usuario.dart';
import 'janelas/cadastro/janela_cadastro.dart';
import 'janelas/cadastro/janela_cadastro_c.dart';
import 'janelas/login/janela_login.dart';
import 'janelas/login/janela_login_c.dart';
import 'janelas/paineis/administrador/painel_administrador.dart';
import 'janelas/paineis/funcionario/painel_funcionario.dart';
import 'janelas/paineis/funcionario/painel_funcionario_c.dart';
import 'janelas/paineis/gerente/painel_gerente.dart';

class AplicacaoC extends GetxController {
  String chaveCacheConfiguracaoApp = "configuracao_app";
  static String chaveUsuarioDonoDefinitivo = "usuarioDonoDefinitivo";
  bool sistemaAutenticado = false;
  static Usuario? _usuarioActual;
  late BuildContext context;

  @override
  Future<void> onInit() async {
    // Get.put(BancoDados());
    // var def = ManipularDefinicoes(ProvedorDefinicoes());
    // Get.put(def);
    super.onInit();
  }

  Usuario? pegarUsuarioActual() => _usuarioActual;

  static void definirUsuarioActual(Usuario? usuario) {
    _usuarioActual = usuario;
  }

  static void irParaJanelaLogin() async {
    Get.off(() => JanelaLogin());
  }

  static void voltar({instanciaNaMemoria}) async {
    Get.back();
    if (instanciaNaMemoria != null) {
      removerIntanciaDaMemoria(instanciaNaMemoria);
    }
  }

  static void logar(Usuario usuario) async {
    if (usuario.nivelAcesso == null) {
      voltar();
      voltar();
      return;
    }
    definirUsuarioActual(usuario);
    mostrar(NivelAcesso.paraTexto(usuario.nivelAcesso??0));
    if (usuario.nivelAcesso == NivelAcesso.ADMINISTRADOR) {
      irParaPainelAdministrador();
      return;
    }
    if (usuario.nivelAcesso == NivelAcesso.GERENTE) {
      irParaPainelGerente();
      return;
    }
    if (usuario.nivelAcesso == NivelAcesso.FUNCIONARIO) {
      var c = Get.put(PainelFuncionarioC());
      await c.inicializarFuncionario();
      irParaPainelFuncionario();
      return;
    }
    if (usuario.nivelAcesso == NivelAcesso.CLIENTE) {
      irParaPainelCliente();
      return;
    }
  }

  static void terminarSessao() {
    ManipularUsuario(ProvedorNetUsuario()).terminarSessao(_usuarioActual!);
    definirUsuarioActual(null);
    irParaJanelaLogin();
  }


  static void irParaJanelaCadastro(BuildContext context) async {
    // ManipularDefinicoes def = Get.find();
    // try {
    //   await def.autenticaSistema();
    //   voltar();
    // } catch (e) {
    //   voltar();
    //   if (e is SocketException) {
    //     mostrarDialogoDeInformacao("Sem Ligação à Internet!");
    //     return;
    //   }
    //   if (e is ErroLicencaExpirada) {
    //     mostrarDialogoDeLayou(
    //         LayoutConfirmacaoAccao(
    //             corButaoSim: primaryColor,
    //             pergunta: "${e.sms}\n\nValidar via Internet?",
    //             accaoAoConfirmar: () async {
    //               mostrarCarregandoDialogoDeInformacao("Validando...");
    //               try {
    //                 await def.validarLicencaDaNet(
    //                     await def.pegarDefinicoesActuais(), DateTime.now());
    //                 voltar();
    //               } on Erro catch (e) {
    //                 voltar();
    //                 mostrarDialogoDeInformacao(e.sms);
    //               }
    //             },
    //             accaoAoCancelar: () {}),
    //         layoutCru: true);
    //     return;
    //   }
    //   mostrarDialogoDeInformacao((e as Erro).sms);
    //   return;
    // }
    Get.to(() => JanelaCadastro());
  }

  static void irParaPainelAdministrador() {
    Get.off(() => PainelAdministrador());
  }

  static void irParaPainelGerente() {
    Get.off(() => PainelGerente());
  }

  static void irParaPainelFuncionario() {
    Get.off(() => PainelFuncionario());
  }
  
  static void irParaPainelCliente() {
    Get.off(() => PainelCliente());
  }

  static void irParaJanelaPainelUsuario(Usuario usuario) {}

  static void removerIntanciaDaMemoria(instanciaNaMemoria) {
    instanciaNaMemoria.runtimeType;
    if (instanciaNaMemoria is JanelaLoginC) {
      Get.delete<JanelaLoginC>();
      return;
    }
    if (instanciaNaMemoria is JanelaCadastroC) {
      Get.delete<JanelaCadastroC>();
      return;
    }
  }
}

AplicacaoC pegarAplicacaoC() {
  return Get.find();
}
