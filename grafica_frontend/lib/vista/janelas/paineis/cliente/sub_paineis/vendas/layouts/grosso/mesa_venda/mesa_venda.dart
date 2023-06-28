import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:componentes_visuais/componentes/icone_item.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/solucoes_uteis/formato_dado.dart';
import '../../../../../../../../../dominio/entidades/funcionario.dart';
import '../../../../../../../../../dominio/entidades/produto.dart';
import '../../../../../../../../../recursos/constantes.dart';
import '../../../../../../../../componentes/item_item_venda.dart';
import '../../../../../../../../componentes/pesquisa.dart';
import '../../vendas_c.dart';
import 'mesa_venda_c.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as viewer;

class LayoutMesaVenda extends StatelessWidget {
  late VendasC _vendasC;
  late MesaVendaC _c;
  Map<String, TextEditingController> controladores = {};

  final DateTime data;
  LayoutMesaVenda(this.data) {
    initiC();
  }

  initiC() async {
    _c = MesaVendaC(data, Funcionario());
    try {
      _vendasC = Get.find();
      _vendasC.data = data;
    } catch (e) {
      _vendasC = Get.put(VendasC(data, Funcionario()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * .99,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: _PainelDireito(c: _c, controladores: controladores),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 20,
                ),
                ModeloButao(
                  corButao: primaryColor,
                  corTitulo: Colors.white,
                  butaoHabilitado: true,
                  tituloButao: "Adicionar Produto",
                  icone: Icons.add,
                  metodoChamadoNoClique: () {
                    mostrarDialogoDeLayou(
                        Container(
                            height: MediaQuery.of(context).size.height * .7,
                            width: MediaQuery.of(context).size.width * .4,
                            child: Produtos(_c, controladores, accaoAoVoltar: (){voltar();},)),
                        layoutCru: true);
                  },
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
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
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ModeloButao(
                    corButao: primaryColor,
                    corTitulo: Colors.white,
                    butaoHabilitado: true,
                    tituloButao: "Finalizar Venda",
                    metodoChamadoNoClique: () {
                      _c.vender(_vendasC);
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class _PainelDireito extends StatelessWidget {
  const _PainelDireito({
    Key? key,
    required MesaVendaC c,
    required this.controladores,
  })  : _c = c,
        super(key: key);

  final MesaVendaC _c;
  final Map<String, TextEditingController> controladores;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.2)),
              borderRadius: BorderRadius.circular(7)),
          child: _CabecaclhoVenda(c: _c),
        ),
        Obx(
          () => Container(
            height: MediaQuery.of(context).size.height * .3,
            padding: EdgeInsets.all(20),
            child: Scrollbar(
              interactive: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _c.listaItensVenda
                      .map((element) => ItemItemVenda(
                            controladores: controladores,
                            element: element,
                            permissao: false,
                            c: _c,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CabecaclhoVenda extends StatelessWidget {
  const _CabecaclhoVenda({
    Key? key,
    required MesaVendaC c,
  })  : _c = c,
        super(key: key);

  final MesaVendaC _c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(
              () => Text(
                  "Total a Pagar: ${formatar(_c.listaItensVenda.fold<double>(0, (previousValue, element) => ((element.total ?? 0) + previousValue)))} KZ"),
            ),
            Spacer(),
            ModeloButao(
              corButao: primaryColor,
              corTitulo: Colors.white,
              butaoHabilitado: true,
              tituloButao: "Pagar",
              icone: Icons.add,
              metodoChamadoNoClique: () {
                _c.mostrarFormasPagamento(context);
              },
            )
          ],
        ),
        Container(width: 200, child: Divider()),
        Row(
          children: [
            Obx(() => Text(
                "Total Pago: ${formatar(_c.listaPagamentos.fold<double>(0, (previousValue, element) => ((element.valor ?? 0) + previousValue)))} KZ")),
            Spacer(),
            Text("Data de levantamento: "),
            Obx(() {
              return ToggleButtons(
                  selectedColor: primaryColor,
                  onPressed: (i) {
                    _c.mudarData(i, context);
                  },
                  children: [
                    Text("Amanhâ"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_c.dataLevantamento.value == null
                          ? "Seleccionar"
                          : "${formatarMesOuDia(_c.dataLevantamento.value!.day)}/${formatarMesOuDia(_c.dataLevantamento.value!.month)}/${_c.dataLevantamento.value!.year} às ${formatarMesOuDia(_c.dataLevantamento.value!.hour)}h e ${formatarMesOuDia(_c.dataLevantamento.value!.minute)}min"),
                    ),
                  ],
                  isSelected: _c.hojeOuData);
            })
          ],
        ),
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _c.listaPagamentos
                  .map((element) => InkWell(
                        onTap: () async {
                          if (element.comprovativo?.arquivo != null) {
                            mostrarDialogoDeLayou(Container(
                              width: MediaQuery.of(context).size.width * .5,
                              height: MediaQuery.of(context).size.height * .5,
                              child: viewer.SfPdfViewer.memory(
                                  element.comprovativo!.arquivo!.bytes!),
                            ));
                            return;
                          }
                          var c = await _c
                              .pegarComprovativoDoPagamentoDeId(element.id!);
                          if (c == null) {
                            mostrarDialogoDeInformacao("Sem Comprovativo!");
                            return;
                          }

                          mostrarDialogoDeLayou(Container(
                            width: MediaQuery.of(context).size.width * .5,
                            height: MediaQuery.of(context).size.height * .5,
                            child: viewer.SfPdfViewer.network(
                                "$URL_STORAGE${c.link!}"),
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${formatar(element.valor ?? 0)} KZ - Pago com ${element.formaPagamento?.descricao ?? "[Não Definido]"}"),
                            IconeItem(
                                metodoQuandoItemClicado: () {
                                  _c.removerPagamento(element);
                                },
                                icone: Icons.delete,
                                titulo: ""),
                          ],
                        ),
                      ))
                  .toList(),
            )),
        Container(width: 200, child: Divider()),
      ],
    );
  }
}

class Produtos extends StatelessWidget {
  late VendasC _vendasC;
  late MesaVendaC _c;
  RxList<Produto> lista = RxList<Produto>([]);
  List<Produto> listaCopia = [];
  final Map<String, TextEditingController> controladores;
  var baixando = false.obs;
  Function? accaoAoVoltar;

  Produtos(this._c, this.controladores, {this.accaoAoVoltar}) {
    _vendasC = Get.find();
    init();
  }
  init() async {
    baixando.value = true;
    var dados = await _vendasC.pegarListaProdutos();
    lista.addAll(dados);
    listaCopia = dados;
    baixando.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: LayoutPesquisa(
              accaoAoVoltar: () {
                if (accaoAoVoltar != null) {
                  accaoAoVoltar!();
                }
              },
              accaoNaInsercaoNoCampoTexto: (dado) {
                mostrar(dado);
                lista.clear();
                if (dado.isNotEmpty) {
                  for (var cada in listaCopia) {
                    if ((cada.nome ?? "")
                        .toLowerCase()
                        .contains(dado.toLowerCase())) {
                      lista.add(cada);
                    }
                  }
                } else {
                  lista.addAll(listaCopia);
                }
              },
            ),
          ),
          Obx(() {
            return Visibility(
                visible: baixando.value,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: const LinearProgressIndicator(),
                ));
          }),
          Obx(() {
            return Visibility(
                visible: lista.isEmpty,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: const Text("Sem Itens!"),
                ));
          }),
          Container(
            height: MediaQuery.of(context).size.height * .5,
            width: MediaQuery.of(context).size.width * .4,
            margin: EdgeInsets.only(top: 20),
            child: Obx(() {
              return Visibility(
                visible: lista.isNotEmpty,
                child: ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (c, i) {
                      var produto = lista[i];
                      return InkWell(
                        onTap: () async {
                          var teste = _c.listaItensVenda.firstWhereOrNull(
                              (element) => element.idProduto == produto.id);
                          if (teste != null) {
                            mostrarDialogoDeInformacao(
                                "Este produto já foi adicionado!",
                                naoFechar: true);
                            return;
                          }
                          mostrarCarregandoDialogoDeInformacao(
                              "Verificando Stock e Preços...",
                              naoFecharJanela: true);
                          produto.stock =
                              await _c.pegarStockDoProdutoDeId(produto.id!);
                          var precos =
                              (await _c.pegarPrecoDoProdutoDeId(produto.id!));
                          voltar();
                          if (precos.isEmpty) {
                            mostrarDialogoDeInformacao(
                                "Produto ${produto.nome ?? "Sem Nome"} sem Preço de Venda");
                            return;
                          } else {
                            produto.precoGeral = precos[0].preco!;
                          }
                          if (produto.stock != null) {
                            if (produto.stock!.quantidade! > 0) {
                              if (produto.precoGeral >= 0) {
                                _c.adicionarProdutoAmesa(produto);
                                controladores["${produto.id}1"] =
                                    TextEditingController(text: "0");
                                controladores["${produto.id}2"] =
                                    TextEditingController(text: "0");
                              } else {
                                mostrarDialogoDeInformacao(
                                    "Produto sem preço!");
                              }
                            } else {
                              mostrarDialogoDeInformacao(
                                  "Produto com quantidade insuficiente em Stock!");
                            }
                          } else {
                            mostrarDialogoDeInformacao("Produto sem Stock!");
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(lista[i].nome ?? "Sem Nome"),
                          ),
                        ),
                      );
                    }),
              );
            }),
            // child: LayoutProdutos(
            //   lista: lista,
            //   permissao: false,
            //   accaoAoClicarCadaProduto: (produto) {
            //     if (produto.stock!.quantidade! > 0) {
            //       if (produto.precoGeral >= 0) {
            //         _c.adicionarProdutoAmesa(produto);
            //         controladores["${produto.id}1"] =
            //             TextEditingController(text: "0");
            //         controladores["${produto.id}2"] =
            //             TextEditingController(text: "0");
            //       } else {
            //         mostrarDialogoDeInformacao(
            //             "Produto sem preço!");
            //       }
            //     } else {
            //       mostrarDialogoDeInformacao(
            //           "Produto com quantidade insuficiente em Stock!");
            //     }
            //   },
            // )
          )
        ],
      ),
    );
  }
}
