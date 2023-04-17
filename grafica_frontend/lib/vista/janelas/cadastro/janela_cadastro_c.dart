import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_fincionario.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_usuario.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/vista/aplicacao_c.dart';

import '../../../contratos/casos_uso/manipular_funcionario_i.dart';
import '../../../fonte_dados/erros.dart';
import '../../../fonte_dados/provedores_net/provedor_net_funcionario.dart';
import '../../../fonte_dados/provedores_net/provedor_net_usuario.dart';
import '../../../solucoes_uteis/console.dart';

class JanelaCadastroC extends GetxController {
  late ManipularFuncionarioI _manipularFuncionarioI;
  JanelaCadastroC() {
    _manipularFuncionarioI = ManipularFuncionario(
        ManipularUsuario(ProvedorNetUsuario()), ProvedorNetFuncionario());
  }
  @override
  void onInit() async {
    await iniciarDependencias();
    super.onInit();
  }

  Future<void> iniciarDependencias() async {}

  Future<void> prepararAmbineteMediacao() async {}

  Future<void> orientarRealizacaoCadastro(
      String nome, String palavraPasse) async {
    if (ValidacaoCampos.camposVazio([nome, palavraPasse]) == true) {
      mostrarDialogoDeInformacao("Preencha todos os campos!");
      return;
    }

    try {
      var novoUsuario = await _manipularFuncionarioI.adicionarFuncionario(
          Funcionario(nomeCompelto: nome, palavraPasse: palavraPasse));
      mostrarDialogoDeInformacao("""
      Cadastro realizado!\n
      Seu nome de Usuario é: ${novoUsuario.nomeUsuario}
      """, accaoAoSair: () {
        AplicacaoC.logar(novoUsuario);
      });
    } catch (e) {
      mostrar(e);
      if (e is Erro) {
        mostrarSnack(e.sms);
      } else {
        mostrarDialogoDeInformacao("Erro Desconhecido no Cadastro");
      }
    }
  }
}
