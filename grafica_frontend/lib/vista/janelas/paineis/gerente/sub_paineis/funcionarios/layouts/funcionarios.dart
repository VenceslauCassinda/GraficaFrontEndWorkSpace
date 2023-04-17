import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/dominio/entidades/painel_actual.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/painel_gerente_c.dart';

import '../../../../../../componentes/item_funcionario.dart';

class LayoutFuncionarios extends StatelessWidget {
  const LayoutFuncionarios({
    Key? key,
    required PainelGerenteC c,
  })  : _c = c,
        super(key: key);

  final PainelGerenteC _c;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: _c.lista.length,
            itemBuilder: (c, i) => ItemFuncionario(
                  usuario: _c.lista[i],
                  aoClicar: () {
                    _c.escolherDataVerVenda(context, _c.lista[i]);
                  },
                )),
      ),
    );
  }
}
