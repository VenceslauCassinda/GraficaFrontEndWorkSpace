import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/modelo_item_lista.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/tipo_produto.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import '../../../../../../recursos/constantes.dart';
import '../../../../../componentes/tab_bar.dart';
import '../../../../../componentes/pesquisa.dart';
import 'painel_c.dart';

class PainelServicos extends StatelessWidget {
  late ServicosC _c;
  Function? accaoAoVoltar;
  PainelServicos({Key? key, this.accaoAoVoltar}) {
    initiC();
  }

  initiC() {
    try {
      _c = Get.find();
    } catch (e) {
      _c = Get.put(ServicosC());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: LayoutPesquisa(
            accaoNaInsercaoNoCampoTexto: (dado) {},
            accaoAoSair: () {
              _c.terminarSessao();
            },
            accaoAoVoltar: () {
              accaoAoVoltar!();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              Text(
                "PERSONALIZAÇÃO",
                style: TextStyle(color: primaryColor),
              ),
              Spacer(),
              Expanded(
                  child: ModeloTabBar(
                listaItens: ["Serviços", "Temas"],
                indiceTabInicial: 0,
                accao: (indice) {
                  _c.indiceTab.value = indice;
                },
              ))
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
              return Visibility(
                visible: _c.indiceTab.value == 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(() {
                      if (_c.servicos.value == null) {
                        return CircularProgressIndicator();
                      }
                      return Visibility(
                        visible: _c.servicos.value!.isNotEmpty,
                        replacement: Text("Sem dados!"),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _c.servicos.value!
                              .map((cada) => InkWell(
                                    onTap: () {},
                                    child: ModeloItemLista(
                                      tituloItem: cada.servico ?? "Sem nome",
                                      itemRemovivel: true,
                                      subTituloItem:
                                          TipoProduto.paraTexto(cada.tipo ?? 0),
                                      labelSubTituloItem:
                                          "Aplicável Produto do Tipo: ",
                                      metodoChamadoAoRemoverItem: () {
                                        _c.mostrarDialogoRemoverServico(cada);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ),
                replacement: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(() {
                      if (_c.temas.value == null) {
                        return CircularProgressIndicator();
                      }
                      return Visibility(
                        visible: _c.temas.value!.isNotEmpty,
                        replacement: Text("Sem dados!"),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _c.temas.value!
                              .map((cada) => InkWell(
                                    onTap: () {},
                                    child: ModeloItemLista(
                                      tituloItem: cada.tema ?? "Sem nome",
                                      itemRemovivel: true,
                                      metodoChamadoAoRemoverItem: () {
                                        _c.mostrarDialogoRemoverTema(cada);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(() {
              return Visibility(
                visible: _c.indiceTab.value == 0,
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(20),
                  child: ModeloButao(
                    corButao: primaryColor,
                    corTitulo: Colors.white,
                    butaoHabilitado: true,
                    icone: Icons.add,
                    tituloButao: "Novo Serviço",
                    metodoChamadoNoClique: () {
                      _c.mostrarDialogoAdicionarFormaServico();
                    },
                  ),
                ),
              );
            }),
            Obx(() {
              return Visibility(
                visible: _c.indiceTab.value == 1,
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(20),
                  child: ModeloButao(
                    corButao: primaryColor,
                    corTitulo: Colors.white,
                    butaoHabilitado: true,
                    icone: Icons.add,
                    tituloButao: "Novo Tema",
                    metodoChamadoNoClique: () {
                      _c.mostrarDialogoAdicionarTema();
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
