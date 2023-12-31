import 'package:componentes_visuais/componentes/info_gaveta.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:componentes_visuais/componentes/item_gaveta.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/painel_actual.dart';
import 'package:grafica_frontend/recursos/constantes.dart';
import 'package:grafica_frontend/vista/componentes/logo.dart';

import '../../../../../dominio/entidades/funcionario.dart';
import '../painel_funcionario_c.dart';
import '../sub_paineis/vendas/layouts/vendas_c.dart';

class GavetaNavegacao extends StatelessWidget {
  final String linkImagem;
  final PainelFuncionarioC c;

  const GavetaNavegacao({Key? key, required this.linkImagem, required this.c})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              height: 200,
              child: Logo(
                cor: primaryColor,
                tamanhoTexto: 30.sp,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20))),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<Funcionario>(
                       future: c.inicializarFuncionario(),
                      builder: (c, s) {
                        if (s.data == null) {
                          return CircularProgressIndicator();
                        }
                        return Container(
                          child: InfoGaveta(
                            cor: branca,
                            titulo: "${s.data!.nomeCompelto}",
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),
                  ItemDaGaveta(
                      cor: branca,
                      icone: Icons.home,
                      titulo: "Início",
                      metodoQuandoItemClicado: () async {
                        c.irParaPainel(PainelActual.INICIO);
                        voltar();
                      }),
                  ItemDaGaveta(
                      cor: branca,
                      icone: Icons.logout,
                      titulo: "Sair",
                      metodoQuandoItemClicado: () async {
                        c.terminarSessao();
                      }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
