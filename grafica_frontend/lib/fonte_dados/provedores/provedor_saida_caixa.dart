import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/saida_caixa.dart';

import '../../contratos/provedores/provedor_saida_caixa_i.dart';

class ProvedorSaidaCaixa implements ProvedorSaidaCaixaI {
  late var _saidaCaixaDao;
  ProvedorSaidaCaixa() {
  }
  @override
  Future<bool> actualizarSaidaCaixa(SaidaCaixa saidaCaixa) async {
    return await _saidaCaixaDao.actualizar(saidaCaixa);
  }

  @override
  Future<int> adicionarSaidaCaixa(SaidaCaixa saidaCaixa) async {
    return await _saidaCaixaDao.adcionarSaidaCaixa(saidaCaixa);
  }

  @override
  Future<List<SaidaCaixa>> pegarLista() async {
    return await _saidaCaixaDao.todos();
  }

  @override
  Future<int> removerSaidaCaixaDeId(int id) async {
    return await _saidaCaixaDao.removerSaidaCaixaDeId(id);
  }

  @override
  Future<void> removerTudo() async {
    await _saidaCaixaDao.removerTudo();
  }

  @override
  @override
  Future<void> removerAntesDe(DateTime data) async {
    await _saidaCaixaDao.removerAntes(data);
  }
}
