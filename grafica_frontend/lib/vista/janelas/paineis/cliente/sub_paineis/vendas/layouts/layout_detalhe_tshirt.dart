import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/menu_drop_down.dart';
import 'package:componentes_visuais/componentes/modelo_item_lista.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/tipo_detalhe.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/vista/janelas/paineis/cliente/sub_paineis/vendas/layouts/grosso/mesa_venda/mesa_venda_c.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../../../dominio/entidades/cores.dart';
import '../../../../../../../dominio/entidades/detalhe_item.dart';
import '../../../../../../../dominio/entidades/evento.dart';
import '../../../../../../../dominio/entidades/item_venda.dart';
import '../../../../../../../dominio/entidades/tema.dart';
import '../../../../../../../fonte_dados/provedores_net/provedor_net_evento.dart';
import '../../../../../../../fonte_dados/provedores_net/provedor_net_tema.dart';
import '../../../../../../../recursos/constantes.dart';
import '../../../componentes/campo_texto_detalhe.dart';
import 'layout_cada_detalhe.dart';

class LayoutDetalheTshirt extends StatelessWidget {
  RxList<DetalheItem> detalhes = RxList<DetalheItem>([]);
  LayoutDetalheTshirt({
    super.key,
    required this.corCampoTexto,
    required this.corProduto,
    required this.itemVenda,
    required this.c,
  }) {
    if (itemVenda.detalhes.isNotEmpty) {
      detalhes.value = itemVenda.detalhes;
    }
  }

  final Rx<Color> corCampoTexto;
  final Color corProduto;
  final MesaVendaC c;
  String dizeresFrente = "";
  String dizeresTras = "";
  String? tema;
  String? evento;
  String? corLetra;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text("${itemVenda.produto?.nome ?? "Produto Sem Nome"}"),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: 30,
                    child: ModeloButao(
                      icone: Icons.add,
                      corButao: Colors.green,
                      corTitulo: Colors.white,
                      butaoHabilitado: true,
                      tituloButao: "Acicionar Detalhe",
                      metodoChamadoNoClique: () {
                        mostrarDialogoDeLayou(
                            LayoutCadaDetalhe(
                              accaoAoFinalizar:
                                  (dizeres, cor, nomeDetalhe, tipoDetalhe, arquivo) {
                                detalhes.insert(0,DetalheItem(
                                    idVista: DateTime.now().toIso8601String(),
                                    idItem: itemVenda.id,
                                    arquivo: arquivo,
                                    detalhe: nomeDetalhe,
                                    dizeres: dizeres,
                                    nomeCor: cor,
                                    tipo:tipoDetalhe));
                                            voltar()
;                              },
                              titulo: "Insira os detalhes!",
                            ),
                            layoutCru: true);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width *.8,
            height: MediaQuery.of(context).size.height *.6,
            child: Obx(
              () {
                return ListView.builder(
                  itemCount: detalhes.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(detalhes[i].detalhe ?? "Sem Nome"),
                                Visibility(
                                  visible: detalhes[i].tipo != null,
                                    child: Text("Tipo de Detalhe: ${TipoDetalhe.paraTexto(detalhes[i].tipo??0)}")),
                                Visibility(
                                  visible: detalhes[i].nomeCor != null,
                                    child: Text("Cor Seleccionada: ${Cores.paraColor(detalhes[i].nomeCor??Cores.paraListaCoresEmTexto()[0])}")),
                                Visibility(
                                  visible: detalhes[i].dizeres != null,
                                    child: Text("Dizeres: ${detalhes[i].dizeres}")),
                                Visibility(
                                  visible: detalhes[i].tipo == TipoDetalhe.IMAGEM  || detalhes[i].tipo == TipoDetalhe.TEXTO,
                                    child: InkWell(
                                      child: Row(
                                        children: [
                                          Text("Ver Imagem"),
                                          Icon(Icons.visibility)
                                        ],
                                      ),
                                      onTap: () {
                                        if(detalhes[i].arquivo != null){
                                          mostrarDialogoDeLayou(Image.memory(detalhes[i].arquivo!.bytes!));
                                          return;
                                        }
                                        if(detalhes[i].link != null){
                                          mostrarDialogoDeLayou(Image.network(detalhes[i].link!));
                                          return;
                                        }
                                        mostrarDialogoDeInformacao("Nenhuma Imagem!");
                                      },
                                    )),
                              ]),
                              Spacer(),
                              InkWell(
                              child: Icon(Icons.delete),
                              onTap: () {
                                detalhes.removeWhere((element) {
                                  return element.idVista == detalhes[i].idVista;
                                },);
                              },
                            )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
          Container(
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
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ModeloButao(
                    corButao: primaryColor,
                    corTitulo: Colors.white,
                    butaoHabilitado: true,
                    tituloButao: "Salvar",
                    metodoChamadoNoClique: () {
                      c.salvarDetalhe(itemVenda, detalhes);
                      voltar();
                    },
                  ),
                ),
              ],
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
