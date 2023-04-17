import 'package:get/get.dart';
import 'package:grafica_frontend/contratos/provedores/provedor_definicoes_i.dart';
import 'package:grafica_frontend/dominio/entidades/definicoes.dart';

class ProvedorDefinicoes implements ProvedorDefinicoesI {
  late var _definicoesDao;
  ProvedorDefinicoes() {
  }
  @override
  Future<void> actualizarDefinicoes(Definicoes dado) async {
    await _definicoesDao.atualizarDefinicoes(dado);
  }

  @override
  Future<Definicoes> pegarDefinicoesActuais() async {
    return await _definicoesDao.pegarDefinicoes();
  }
}
