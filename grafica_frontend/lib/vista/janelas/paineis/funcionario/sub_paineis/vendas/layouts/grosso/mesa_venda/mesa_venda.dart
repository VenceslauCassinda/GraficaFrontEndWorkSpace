import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:componentes_visuais/componentes/icone_item.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/solucoes_uteis/formato_dado.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/vendas/layouts/grosso/mesa_venda/mesa_venda_c.dart';
import '../../../../../../../../../dominio/entidades/funcionario.dart';
import '../../../../../../../../../dominio/entidades/produto.dart';
import '../../../../../../../../../recursos/constantes.dart';
import '../../../../../../../../componentes/item_item_venda.dart';
import '../../../../../../../../componentes/pesquisa.dart';
import '../../../../../../gerente/sub_paineis/produtos/layouts/produtos.dart';
import '../../vendas_c.dart';

class LayoutMesaVenda extends StatelessWidget {
  late VendasC _vendasC;
  late MesaVendaC _c;
  Map<String, TextEditingController> controladores = {};
  RxList<Produto> lista = RxList<Produto>([]);

  final DateTime data;
  final Funcionario funcionario;
  LayoutMesaVenda(this.data, this.funcionario) {
    _c = MesaVendaC(data, funcionario);
    initiC();
  }

  initiC() async {
    try {
      _vendasC = Get.find();
      _vendasC.data = data;
      _vendasC.funcionario = funcionario;
    } catch (e) {
      _vendasC = Get.put(VendasC(data, funcionario));
    }
    await pegarDados();
  }

  Future<void> pegarDados() async {
    var res = await _vendasC.pegarListaProdutos();
    for (var cada in res) {
      lista.add(cada);
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
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: LayoutPesquisa(
                          accaoNaInsercaoNoCampoTexto: (dado) {
                            // _vendasC.aoPesquisarProduto(dado);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: FutureBuilder<List<Produto>>(
                            future: _vendasC.pegarListaProdutos(),
                            builder: (c, s) {
                              if (s.data == null) {
                                return Container(
                                  child: const LinearProgressIndicator(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                );
                              }
                              return Container(
                                height: MediaQuery.of(context).size.height * .5,
                                margin: const EdgeInsets.only(top: 20),
                                child: ListView.builder(
                                    itemCount: lista.length,
                                    itemBuilder: (c, i) {
                                      var produto = lista[i];
                                      return InkWell(
                                        onTap: () async {
                                          mostrarCarregandoDialogoDeInformacao(
                                              "Verificando Stock e Preços...",
                                              naoFecharJanela: true);
                                          produto.stock =
                                              await _c.pegarStockDoProdutoDeId(
                                                  produto.id!);
                                          var precos =
                                              (await _c.pegarPrecoDoProdutoDeId(
                                                  produto.id!));
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
                                                    TextEditingController(
                                                        text: "0");
                                                controladores["${produto.id}2"] =
                                                    TextEditingController(
                                                        text: "0");
                                              } else {
                                                mostrarDialogoDeInformacao(
                                                    "Produto sem preço!");
                                              }
                                            } else {
                                              mostrarDialogoDeInformacao(
                                                  "Produto com quantidade insuficiente em Stock!");
                                            }
                                          } else {
                                            mostrarDialogoDeInformacao(
                                                "Produto sem Stock!");
                                          }
                                        },
                                        child: Card(
                                          elevation: 5,
                                          child:
                                              Padding(
                                                padding: const EdgeInsets.all(20),
                                                child: Text(lista[i].nome ?? "Sem Nome"),
                                              ),
                                        ),
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
                              );
                            }),
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*.60,child: VerticalDivider()),
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
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.2)),
              borderRadius: BorderRadius.circular(7)),
          child: _CabecaclhoVenda(c: _c),
        ),
        Obx(
          () => Container(
            height: MediaQuery.of(context).size.height * .3,
            padding: const EdgeInsets.all(20),
            child: Scrollbar(
              interactive: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _c.listaItensVenda
                      .map((element) => ItemItemVenda(
                            controladores: controladores,
                            c: _c,
                            element: element,
                            permissao: true,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        )
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
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Cliente: ",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * .18,
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    onChanged: (valor) {
                      _c.nomeCliente.value = valor;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("Contacto: ", style: TextStyle(fontSize: 20)),
                ),
                Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * .18,
                  child: TextField(
                      onChanged: (valor) {
                        _c.telefoneCliente.value = valor;
                      },
                      style: const TextStyle(fontSize: 20),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                ),
              ],
            ),
            const Spacer(),
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
        const SizedBox(
          height: 10,
        ),
        Container(width: 200, child: const Divider()),
        Obx(
          () => Text(
              "Total a Pagar: ${formatar(_c.listaItensVenda.fold<double>(0, (previousValue, element) => ((element.total ?? 0) + previousValue)))} KZ"),
        ),
        Row(
          children: [
            Obx(() => Text(
                "Total Pago: ${formatar(_c.listaPagamentos.fold<double>(0, (previousValue, element) => ((element.valor ?? 0) + previousValue)))} KZ")),
            const Spacer(),
            const Text("Data de levantamento: "),
            Obx(() {
              return ToggleButtons(
                  selectedColor: primaryColor,
                  onPressed: (i) {
                    _c.mudarData(i, context);
                  },
                  children: [
                    const Text("Hoje"),
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
                  .map((element) => Row(
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
                      ))
                  .toList(),
            )),
        Container(width: 200, child: const Divider()),
      ],
    );
  }
}
