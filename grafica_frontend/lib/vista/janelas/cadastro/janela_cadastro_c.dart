import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_cliente.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_fincionario.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_usuario.dart';
import 'package:grafica_frontend/dominio/entidades/cliente.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/fonte_dados/provedores_net/provedor_net_cliente.dart';
import 'package:grafica_frontend/vista/aplicacao_c.dart';

import '../../../contratos/casos_uso/manipular_funcionario_i.dart';
import '../../../fonte_dados/erros.dart';
import '../../../fonte_dados/provedores_net/provedor_net_funcionario.dart';
import '../../../fonte_dados/provedores_net/provedor_net_usuario.dart';
import '../../../solucoes_uteis/console.dart';

class JanelaCadastroC extends GetxController {
  late ManipularFuncionarioI _manipularFuncionarioI;
  bool modoRegitroCliente = true;
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

  Future<void> orientarRealizacaoCadastro(String nome, String palavraPasse,
      {Function(Funcionario novoFuncionario)? aoFinalizar}) async {
    if (ValidacaoCampos.camposVazio([nome, palavraPasse]) == true) {
      mostrarDialogoDeInformacao("Preencha todos os campos!");
      return;
    }

    try {
        mostrarCarregandoDialogoDeInformacao("");
      if (modoRegitroCliente == false) {
        var novo = await _manipularFuncionarioI.adicionarFuncionario(
            Funcionario(nomeCompelto: nome, palavraPasse: palavraPasse));
        voltar();
        mostrarDialogoDeInformacao("""
      Cadastro realizado!\n
      Nome de Usuário: ${novo.nomeUsuario}\n
      Senha: ${novo.palavraPasse}
      """, accaoAoSair: () {
          aoFinalizar!(novo);
        });
      }else{
        var manipularCliente = ManipularCliente(ProvedorNetCliente(), manipularUsuarioI: ManipularUsuario(ProvedorNetUsuario()));
        var novo = await manipularCliente.registarClienteComUsuario(Cliente.regitro(nome: nome, palavraPasse: palavraPasse));
        mostrarDialogoDeInformacao("""
      Cadastro realizado!\n
      Nome de Usuário: ${novo.nomeUsuario}\n
      """, accaoAoSair: () {
          AplicacaoC.logar(novo.usuario!);
        });
      }
    } catch (e) {
      voltar();
      if (e is Erro) {
        mostrarSnack(e.sms);
      }
      if (e.toString().contains("XMLHttpRequest")) {
        mostrarSnack("${e.toString()}\nServidor Indisponível!");
      }
    }
  }
}
