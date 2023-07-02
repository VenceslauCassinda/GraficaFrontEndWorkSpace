import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/menu_drop_down.dart';
import 'package:componentes_visuais/componentes/observadores/observador_butoes.dart';
import 'package:componentes_visuais/componentes/observadores/observador_campo_texto.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';
import '../../../../../../../dominio/entidades/cores.dart';
import '../../../../../../../dominio/entidades/tipo_detalhe.dart';
import '../../../../../../../fonte_dados/provedores_net/provedor_net_detalhe_item.dart';
import '../../../componentes/campo_texto_detalhe.dart';

class LayoutSeleccionarDetalhe extends StatelessWidget {
  late ObservadorCampoTexto _observadorCampoTexto;
  late ObservadorButoes _observadorButoes = ObservadorButoes();

  final Function(
          String? dizeres, String? cor, String? detalhe, int tipoDetalhe, PlatformFile? arquivo)
      accaoAoFinalizar;

  String? nomeDetalhe;
  String? dizeres;
  String? cor;
  Produto? produto;
  final String titulo;
  late BuildContext context;
  var labelArquivo = "Incluir Imagem".obs;
  var tipoDetalhe = 0.obs;
  PlatformFile? arquivo;

  LayoutSeleccionarDetalhe({super.key, 
    required this.accaoAoFinalizar,
    required this.titulo,
    required this.produto,
    nomeDetalhe,
  }) {
    _observadorCampoTexto = ObservadorCampoTexto();
    _observadorButoes = ObservadorButoes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(100),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<TipoDetalhe>>(
                    future: ProvedorNetDetalheItem().pegarTipoDetalhesDeTipoProduto(produto?.tipo??0),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Center(child: Text("Sem dados adicionados!"));
                      }

                      tipoDetalhe.value = snapshot.data!
                              .firstWhere((element) =>
                                  element.detalhe ==
                                  (snapshot.data!.first.detalhe ?? "Sem nome"))
                              .tipo ??
                          0;
                      nomeDetalhe = snapshot.data!
                              .first.detalhe;
                      return Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Detalhe: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              MenuDropDown(
                                labelMenuDropDown:
                                    snapshot.data!.first.detalhe ?? "Sem nome",
                                metodoChamadoNaInsersao: (dado) {
                                  nomeDetalhe = dado;
                                  tipoDetalhe.value = snapshot.data!
                                          .firstWhere((element) =>
                                              element.detalhe == dado)
                                          .tipo ??
                                      0;
                                },
                                listaItens: snapshot.data!
                                    .map((e) => e.detalhe ?? "Sem Nome")
                                    .toList(),
                              ),
                            ],
                          ),
                          Obx(() {
                            return Visibility(
                              visible: tipoDetalhe.value == TipoDetalhe.COR,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Selecionar: "),
                                  MenuDropDown(
                                    labelMenuDropDown:
                                        Cores.paraListaCoresEmTexto()[0],
                                    metodoChamadoNaInsersao: (dado) {
                                      cor = dado;
                                    },
                                    listaItens: Cores.paraListaCoresEmTexto(),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Obx(() {
                            return Visibility(
                              visible: tipoDetalhe.value == TipoDetalhe.TEXTO,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.height * .5,
                                child: CampoTextoDetalhe(
                                  aoDigitar: (novo) {
                                    dizeres = novo;
                                    _observadorCampoTexto.observarCampo(
                                        novo, TipoCampoTexto.generico);
                                    if (novo.isEmpty) {
                                      _observadorCampoTexto.mudarValorValido(
                                          true, TipoCampoTexto.generico);
                                    }
                                    _observadorButoes
                                        .mudarValorFinalizarCadastroInstituicao(
                                            [
                                          novo,
                                        ],
                                            [
                                          true,
                                        ]);
                                  },
                                  corCampoTexto: Colors.black,
                                  corTshirt: Colors.black,
                                  quantidadeLinhas: 3,
                                  dicaTexto: "Informação do Detalhe",
                                ),
                              ),
                            );
                          }),
                          Obx(() {
                            return Visibility(
                              visible: tipoDetalhe.value == TipoDetalhe.TEXTO ||
                                  tipoDetalhe.value == TipoDetalhe.IMAGEM,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return Text(labelArquivo.value);
                                    }),
                                    InkWell(
                                      onTap: () {
                                        selecionarArquivo();
                                      },
                                      child: const Icon(Icons.upload_file, size: 20),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width * .15,
              height: 30,
              child: ModeloButao(
                tituloButao: "Cancelar",
                corButao: Colors.red,
                corTitulo: Colors.white,
                butaoHabilitado: true,
                metodoChamadoNoClique: () async {
                  fecharDialogoCasoAberto();
                },
              ),
            ),
            Obx(() {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * .15,
                height: 30,
                child: ModeloButao(
                  corTitulo: _observadorButoes
                              .butaoFinalizarCadastroInstituicao.value ==
                          true
                      ? Colors.white
                      : Colors.black,
                  corButao: Colors.green,
                  butaoHabilitado: true,
                  tituloButao: "Finalizar",
                  metodoChamadoNoClique: () {
                    if (tipoDetalhe.value == TipoDetalhe.TEXTO) {
                      if (dizeres == null || dizeres!.isEmpty) {
                        mostrarDialogoDeInformacao("Insira os Dizerers!");
                        return;
                      }
                    }
                    if (tipoDetalhe.value == TipoDetalhe.COR) {
                      cor ??= Cores.paraListaCoresEmTexto()[0];
                    }
                    accaoAoFinalizar(dizeres, cor, nomeDetalhe,tipoDetalhe.value, arquivo);
                  },
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  void selecionarArquivo() async {
    var res = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["png", "jpg", "jpeg"]);
    if (res == null) {
      return;
    }
    PlatformFile arquivo = res.files.first;
    labelArquivo.value = arquivo.name;
    this.arquivo = arquivo;
  }
}
