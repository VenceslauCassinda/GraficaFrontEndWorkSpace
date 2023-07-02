import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/tipo_detalhe.dart';
import 'package:grafica_frontend/fonte_dados/provedores_net/provedor_net_detalhe_item.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/vista/janelas/paineis/cliente/sub_paineis/vendas/layouts/grosso/mesa_venda/mesa_venda_c.dart';

import '../../../../../../../dominio/entidades/cores.dart';
import '../../../../../../../dominio/entidades/detalhe_item.dart';
import '../../../../../../../dominio/entidades/item_venda.dart';
import '../../../../../../../recursos/constantes.dart';
import 'layout_seleccionar_detalhe.dart';
import 'dart:js' as js;

class LayoutDetalheTshirt extends StatelessWidget {
  RxList<DetalheItem> detalhes = RxList<DetalheItem>([]);
  LayoutDetalheTshirt({
    super.key,
    required this.corCampoTexto,
    required this.corProduto,
    required this.itemVenda,
    this.c,
    this.aoSalvarDetalhe,
    required this.permissao,
  }) {
    if (itemVenda.detalhes.isNotEmpty) {
      detalhes.addAll(itemVenda.detalhes);
    }
  }

  final bool permissao;

  final Rx<Color> corCampoTexto;
  final Color corProduto;
  MesaVendaC? c;
  String dizeresFrente = "";
  String dizeresTras = "";
  String? tema;
  String? evento;
  String? corLetra;
  Function(ItemVenda itemVenda, List<DetalheItem> lista)? aoSalvarDetalhe;
  var labelArquivo = "Seleccionar Arquivo".obs;
  PlatformFile? arquivo;
  final ItemVenda itemVenda;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .8,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(itemVenda.produto?.nome ?? "Produto Sem Nome"),
                const Spacer(),
                Visibility(
                  visible: permissao,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      height: 30,
                      child: ModeloButao(
                        icone: Icons.add,
                        corButao: Colors.green,
                        corTitulo: Colors.white,
                        butaoHabilitado: true,
                        tituloButao: "Adicionar Detalhe",
                        metodoChamadoNoClique: () {
                          mostrarDialogoDeLayou(
                              LayoutSeleccionarDetalhe(
                                produto: itemVenda.produto,
                                accaoAoFinalizar: (dizeres, cor, nomeDetalhe,
                                    tipoDetalhe, arquivo) {
                                  detalhes.insert(
                                      0,
                                      DetalheItem(
                                          idVista:
                                              DateTime.now().toIso8601String(),
                                          idItem: itemVenda.id,
                                          arquivo: arquivo,
                                          detalhe: nomeDetalhe,
                                          dizeres: dizeres,
                                          nomeCor: cor,
                                          tipo: tipoDetalhe));
                                  voltar();
                                },
                                titulo: "Insira os detalhes!",
                              ),
                              layoutCru: true);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(),
          ),
          Obx(() {
            return Visibility(
              visible: permissao == true,
              replacement: FutureBuilder<List<DetalheItem>>(
                future: ProvedorNetDetalheItem()
                    .pegarDetalhesDeItemId(itemVenda.id ?? 0),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Text("Sem detalhes!");
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.height * .6,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: LayoutItemDetalhe(
                            detalhes: RxList<DetalheItem>(snapshot.data!),
                            i: i,
                            permissao: permissao,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: MediaQuery.of(context).size.height * .6,
                child: ListView.builder(
                  itemCount: detalhes.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: LayoutItemDetalhe(
                        detalhes: detalhes,
                        i: i,
                        permissao: permissao,
                      ),
                    );
                  },
                ),
              ),
            );
          }),
          Visibility(
            visible: permissao,
            child: SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ModeloButao(
                      corButao: Colors.red,
                      corTitulo: Colors.white,
                      butaoHabilitado: true,
                      tituloButao: "Cancelar",
                      metodoChamadoNoClique: () {
                        voltar();
                      },
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: ModeloButao(
                      corButao: primaryColor,
                      corTitulo: Colors.white,
                      butaoHabilitado: true,
                      tituloButao: "Salvar",
                      metodoChamadoNoClique: () {
                        if (aoSalvarDetalhe != null) {
                          aoSalvarDetalhe!(itemVenda, detalhes);
                          return;
                        }
                        c!.salvarDetalhe(itemVenda, detalhes);
                        voltar();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selecionarArquivo() async {
    var res = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ["png", "jpg", "jpeg"]);
    if (res == null) {
      return;
    }
    PlatformFile arquivo = res.files.first;
    labelArquivo.value = arquivo.name;
    this.arquivo = arquivo;
  }
}

class LayoutItemDetalhe extends StatelessWidget {
  const LayoutItemDetalhe({
    super.key,
    required this.detalhes,
    required this.i,
    required this.permissao,
  });

  final RxList<DetalheItem> detalhes;
  final int i;
  final bool permissao;

  @override
  Widget build(BuildContext context) {
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: detalhes[i].tipo == TipoDetalhe.COR,
                      child: Text(
                          "${detalhes[i].detalhe ?? ""}: ${detalhes[i].nomeCor ?? Cores.paraListaCoresEmTexto()[0]}")),
                  Visibility(
                      visible: detalhes[i].tipo == TipoDetalhe.TEXTO,
                      child: Text(
                          "${detalhes[i].detalhe ?? ""}: ${detalhes[i].dizeres}")),
                  Visibility(
                      visible: detalhes[i].tipo == TipoDetalhe.IMAGEM ||
                          detalhes[i].tipo == TipoDetalhe.TEXTO,
                      child: InkWell(
                        child: Row(
                          children: [
                            Visibility(
                              visible: detalhes[i].tipo != TipoDetalhe.TEXTO,
                              replacement: const Text("Ver Imagem"),
                              child: Text(
                                  "${detalhes[i].detalhe ?? ""}: Ver Imagem"),
                            ),
                            const Icon(Icons.visibility)
                          ],
                        ),
                        onTap: () {
                          if (detalhes[i].arquivo != null) {
                            mostrarDialogoDeLayou(
                                Image.memory(detalhes[i].arquivo!.bytes!));
                            return;
                          }
                          if (detalhes[i].link != null) {
                            // js.context.callMethod('open', ["$URL_STORAGE${c.link!}"]);
                            mostrarDialogoDeLayou(
                                Image.network("$URL_STORAGE${detalhes[i].link!}"));
                            return;
                          }
                          mostrarDialogoDeInformacao("Nenhuma Imagem!");
                        },
                      )),
                ]),
            const Spacer(),
            Visibility(
              visible: permissao,
              child: InkWell(
                child: const Icon(Icons.delete),
                onTap: () {
                  detalhes.removeWhere(
                    (element) {
                      return element.idVista == detalhes[i].idVista;
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
