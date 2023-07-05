import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:componentes_visuais/componentes/cabecalho_gaveta.dart';
import 'package:componentes_visuais/componentes/item_gaveta.dart';
import 'package:grafica_frontend/recursos/constantes.dart';
import 'package:grafica_frontend/vista/componentes/logo.dart';
import 'package:grafica_frontend/vista/janelas/login/janela_login.dart';
import 'package:grafica_frontend/vista/janelas/paineis/administrador/painel_administrador_c.dart';

class GavetaNavegacao extends StatelessWidget {
  final String linkImagem;

  const GavetaNavegacao({Key? key, required this.linkImagem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              height: 250,
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
            child: Column(
              children: [
                ItemDaGaveta(
                    cor: branca,
                    icone: Icons.people,
                    titulo: "Usuários",
                    metodoQuandoItemClicado: () async {
                      var c = Get.find<PainelAdministradorC>();
                      await c.pegarUsuarios();
                    }),
                ItemDaGaveta(
                    cor: branca,
                    icone: Icons.logout,
                    titulo: "Sair",
                    metodoQuandoItemClicado: () async {
                      var c = Get.find<PainelAdministradorC>();
                      c.terminarSessao();
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
