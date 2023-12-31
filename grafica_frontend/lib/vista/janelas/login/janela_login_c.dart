import 'dart:io';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_definicoes.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_usuario.dart';
import 'package:grafica_frontend/dominio/entidades/nivel_acesso.dart';
import 'package:grafica_frontend/fonte_dados/erros.dart';
import 'package:grafica_frontend/fonte_dados/provedores/provedores_usuario.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/vista/componentes/sobre_app.dart';
import '../../../contratos/casos_uso/manipular_usuario_i.dart';
import '../../../fonte_dados/provedores_net/provedor_net_usuario.dart';
import '../../aplicacao_c.dart';

class JanelaLoginC extends GetxController {
  bool repositorioWebPreparado = false;

  late ManipularUsuarioI _manipularUsuarioI;

  @override
  void onInit() async {
    _manipularUsuarioI = ManipularUsuario(ProvedorNetUsuario());
    await inicializarDependencias();
    super.onInit();
  }

  Future<void> inicializarDependencias() async {}

  mostrarDialogo(BuildContext context) {
    Get.dialog(Container(
      width: MediaQuery.of(context).size.width * .7,
      height: 200,
      child: const CircularProgressIndicator(),
    ));
  }

  mostrarDialogoSobreApp(BuildContext context) {
    Get.defaultDialog(title: "", content: SobreApp());
  }

  mostrarImagem(BuildContext context, File arquivo) {
    Get.dialog(Container(
      width: MediaQuery.of(context).size.width * .7,
      child: Image.file(arquivo),
    ));
  }

  Future<void> pegarListaUsuario() async {}

  Future<void> fazerLogin(String nome, String palavraPasse) async {
    if (ValidacaoCampos.camposVazio([nome, palavraPasse]) == true) {
      mostrarDialogoDeInformacao("Preencha todos os campos!");
      return;
    }

    try {
      mostrarCarregandoDialogoDeInformacao("");
      var usuario = await _manipularUsuarioI.fazerLogin(nome, palavraPasse);
      AplicacaoC.logar(usuario!);
    } catch (e) {
      voltar();
      if (e is Erro) {
        mostrarSnack(e.sms);
      }if (e.toString().contains("XMLHttpRequest")){
        mostrarSnack("${e.toString()}\nServidor Indisponível!");

      }
    }
  }
}
