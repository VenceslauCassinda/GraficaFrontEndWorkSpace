import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/solucoes_uteis/responsividade.dart';
import '../../../../../recursos/constantes.dart';
import '../../../../componentes/tab_bar.dart';
import '../layouts/detalhes.dart';
import '../layouts/usuarios.dart';
import '../painel_administrador.dart';
import '../painel_administrador_c.dart';

class PainelDireito extends StatelessWidget {
  const PainelDireito({
    Key? key,
    required PainelAdministradorC c,
  })  : _c = c,
        super(key: key);

  final PainelAdministradorC _c;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LayoutPesquisa(c: _c),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              const Text(
                "USUÁRIOS",
                style: TextStyle(color: primaryColor),
              ),
              const Spacer(),
              Expanded(
                  child: ModeloTabBar(
                listaItens: ["Todos", "Activos", "Desactivos", "Eliminados"],
                indiceTabInicial: 0,
                accao: (indice) {
                  _c.navegar(indice);
                },
              )),
              
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutUsuarios(c: _c),
                flex: 2,
              ),
              Obx(() {
                if (_c.usuario.value == null) {
                  return Container();
                }
                return Container();
                // return Expanded(
                //   child: LayoutDetalhes(
                //     c: _c,
                //     usuario: _c.usuario.value!,
                //   ),
                //   flex: 1,
                // );
              })
            ],
          ),
        ),
        Padding(
              padding: const EdgeInsets.all(20),
              child: ModeloButao(
                corButao: primaryColor,
                icone: Icons.add,
                corTitulo: Colors.white,
                butaoHabilitado: true,
                tituloButao: "Novo Gerente",
                metodoChamadoNoClique: () {
                  _c.mostrarDialogoAdicionarFuncionario(context);
                },
              ),
            ),
      ],
    );
  }
}