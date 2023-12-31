import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/casos_uso/manipular_definicoes_i.dart';
import 'package:grafica_frontend/dominio/casos_uso/manipular_definicoes.dart';
import 'package:grafica_frontend/dominio/entidades/definicoes.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/fonte_dados/provedores/provedor_definicoes.dart';

class PainelDefinicoesC extends GetxController {
  late Funcionario funcionario;

  late ManipularDefinicoes _manipularDefinicoesI;

  PainelDefinicoesC(this.funcionario) {
    _manipularDefinicoesI = Get.find();
  }

  late Rx<Definicoes?> definicoesActuais = Rx<Definicoes?>(null);
  @override
  void onInit() async {
    await pegarDados();
    super.onInit();
  }

  Future pegarDados() async {
    var res = await _manipularDefinicoesI.pegarDefinicoesActuais();
    definicoesActuais.value = res;
  }

  Future<void> actualizarDefinicoes(Definicoes nova) async {
    definicoesActuais.value = nova;
    await _manipularDefinicoesI.actualizarDefinicoes(nova);
  }
}
