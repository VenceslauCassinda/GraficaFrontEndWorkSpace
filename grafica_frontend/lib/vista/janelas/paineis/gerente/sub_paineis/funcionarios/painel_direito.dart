import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../recursos/constantes.dart';
import '../../../../../componentes/tab_bar.dart';
import 'layouts/funcionarios.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../painel_gerente_c.dart';

class PainelDireito extends StatelessWidget {
  const PainelDireito({
    Key? key,
    required PainelGerenteC c,
  })  : _c = c,
        super(key: key);

  final PainelGerenteC _c;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: LayoutPesquisa(
            accaoNaInsercaoNoCampoTexto: (dado) {
              _c.aoPesquisar(dado);
            },
            accaoAoSair: () {
              _c.terminarSessao();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              const Text(
                "FUNCIONÁRIOS",
                style: TextStyle(color: primaryColor),
              ),
              Spacer(),
              Expanded(
                  child: ModeloTabBar(
                listaItens: const ["Todos", "Activos", "Desactivos"],
                indiceTabInicial: 0,
                accao: (indice) {
                  _c.navegar(indice);
                },
              ))
            ],
          ),
        ),
        Obx(
          () {
            return Visibility(
              visible: _c.baixando.value == true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(),
              ),
            );
          }
        ),
        Expanded(
          child: LayoutFuncionarios(c: _c),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ModeloButao(
                corButao: primaryColor,
                icone: Icons.add,
                corTitulo: Colors.white,
                butaoHabilitado: true,
                tituloButao: "Novo Funcionário",
                metodoChamadoNoClique: () {
                  _c.mostrarDialogoAdicionarFuncionario(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
