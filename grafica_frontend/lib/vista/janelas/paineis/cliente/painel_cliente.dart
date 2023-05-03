// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';
import 'package:grafica_frontend/solucoes_uteis/responsividade.dart';
import 'package:grafica_frontend/vista/janelas/paineis/cliente/sub_paineis/vendas/painel_vendas.dart';
import '../../../../recursos/constantes.dart';
import 'componentes/gaveta.dart';
import 'painel_cliente_c.dart';

class PainelCliente extends StatelessWidget {
  late PainelClienteC _c;
  PainelCliente({
    Key? key,
  }) : super(key: key) {
    initiC();
  }

  initiC() {
    try {
      _c = Get.find();
    } catch (e) {
      _c = Get.put(PainelClienteC());
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(context);
    return ResponsiveLayoutBuilder(builder: (context, size) {
      Get.put(size);
      return Scaffold(
        drawer: !Responsidade.isDesktop(context)
            ? Container(
                color: branca,
                width: MediaQuery.of(context).size.width * .2,
                child: GavetaNavegacao(
                  linkImagem: "",
                  c: _c,
                ),
              )
            : null,
        appBar: !Responsidade.isDesktop(context)
            ? AppBar(
                backgroundColor: primaryColor,
              )
            : null,
        body: !Responsidade.isDesktop(context)
            ? pegarLayoutPainelAtual()
            : Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: GavetaNavegacao(
                        linkImagem: "",
                        c: _c,
                      )),
                  Expanded(
                    flex: 5,
                    child: pegarLayoutPainelAtual(),
                  ),
                ],
              ),
      );
    });
  }

  pegarLayoutPainelAtual() {
    return Obx(() {
      _c.painelActual.value.indicadorPainel;
      return PainelVendas(
        data: DateTime.now(),
        permissao:false,
        aoTerminarSessao: () {
          _c.terminarSessao();
        },
      );
    });
  }
}
