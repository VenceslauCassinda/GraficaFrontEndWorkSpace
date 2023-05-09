import 'package:componentes_visuais/componentes/info_gaveta.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:componentes_visuais/componentes/item_gaveta.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/cliente.dart';
import 'package:grafica_frontend/dominio/entidades/painel_actual.dart';
import 'package:grafica_frontend/recursos/constantes.dart';
import 'package:grafica_frontend/vista/componentes/logo.dart';
import 'package:grafica_frontend/vista/janelas/paineis/cliente/painel_cliente_c.dart';

import '../../../../../dominio/entidades/funcionario.dart';
import '../sub_paineis/vendas/layouts/vendas_c.dart';

class GavetaNavegacao extends StatelessWidget {
  final String linkImagem;
  final PainelClienteC c;

  const GavetaNavegacao({Key? key, required this.linkImagem, required this.c})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Logo(
              cor: primaryColor,
              tamanhoTexto: 30.sp,
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
                  FutureBuilder<Cliente>(
                       future: c.inicializarCliente(),
                      builder: (c, s) {
                        if (s.data == null) {
                          return CircularProgressIndicator();
                        }
                        return Container(
                          child: InfoGaveta(
                            cor: branca,
                            titulo: "${s.data!.nome}",
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
                        voltar();
                      }),
                  // ItemDaGaveta(
                  //     cor: branca,
                  //     icone: Icons.monetization_on,
                  //     titulo: "Caixa",
                  //     metodoQuandoItemClicado: () async {
                  //       c.irParaPainel(PainelActual.SAIDA_CAIXA);
                  //     }),
                  ItemDaGaveta(
                      cor: branca,
                      icone: Icons.storefront,
                      titulo: "Dívidas",
                      metodoQuandoItemClicado: () async {
                        voltar();
                      }),
                  ItemDaGaveta(
                      cor: branca,
                      icone: Icons.people,
                      titulo: "Clientes",
                      metodoQuandoItemClicado: () async {
                        voltar();
                      }),
                  // ItemDaGaveta(
                  //     cor: branca,
                  //     icone: Icons.arrow_circle_down,
                  //     titulo: "Recepções",
                  //     metodoQuandoItemClicado: () async {
                  //       c.irParaPainel(PainelActual.RECEPCOES);
                  //     }),
                  // ItemDaGaveta(
                  //     cor: branca,
                  //     icone: Icons.monetization_on_outlined,
                  //     titulo: "Dinheiro a mais",
                  //     metodoQuandoItemClicado: () async {
                  //       c.irParaPainel(PainelActual.DINHEIRO_SOBRA);
                  //     }),
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
