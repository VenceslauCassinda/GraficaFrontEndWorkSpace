import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_cliente.dart';
import 'package:grafica_frontend/dominio/entidades/cliente.dart';
import 'package:grafica_frontend/fonte_dados/provedores_net/provedor_net_cliente.dart';

import '../../../../contratos/casos_uso/manipular_funcionario_i.dart';
import '../../../../dominio/casos_uso/manipular_fincionario.dart';
import '../../../../dominio/casos_uso/manipular_usuario.dart';
import '../../../../dominio/entidades/funcionario.dart';
import '../../../../dominio/entidades/painel_actual.dart';
import '../../../../fonte_dados/provedores_net/provedor_net_funcionario.dart';
import '../../../../fonte_dados/provedores_net/provedor_net_usuario.dart';
import '../../../aplicacao_c.dart';

class PainelClienteC extends GetxController {
  var painelActual = PainelActual(indicadorPainel: PainelActual.NENHUM, valor: null).obs;
  late DateTime data;
  Funcionario? funcionarioActual;
  late ManipularFuncionarioI _manipularFuncionarioI;
  PainelClienteC() {
    data = DateTime.now();
    _manipularFuncionarioI = ManipularFuncionario(
        ManipularUsuario(ProvedorNetUsuario()), ProvedorNetFuncionario());
  }
  @override
  void onInit() {
    
    super.onInit();
  }

  Future<Funcionario> inicializarFuncionario() async {
    funcionarioActual =
        await _manipularFuncionarioI.pegarFuncionarioDoUsuarioDeId(
            (pegarAplicacaoC().pegarUsuarioActual())!.id!);
            return funcionarioActual!;
  }
  
  Future<Cliente> inicializarCliente() async {
    var id = pegarAplicacaoC().pegarUsuarioActual()!.id!;
    return (await  ManipularCliente(ProvedorNetCliente()).pegarClienteDeUsuarioDeId(id))!;
  }

  void terminarSessao() {
    AplicacaoC.terminarSessao();
  }
}