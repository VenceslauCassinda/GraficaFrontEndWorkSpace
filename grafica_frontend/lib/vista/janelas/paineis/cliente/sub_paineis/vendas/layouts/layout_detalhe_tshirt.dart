import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/menu_drop_down.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/vista/janelas/paineis/cliente/sub_paineis/vendas/layouts/grosso/mesa_venda/mesa_venda_c.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../../../dominio/entidades/cores.dart';
import '../../../../../../../dominio/entidades/detalhe_item.dart';
import '../../../../../../../dominio/entidades/item_venda.dart';
import '../../../../../../../dominio/entidades/tema.dart';
import '../../../../../../../fonte_dados/provedores_net/provedor_net_tema.dart';
import '../../../../../../../recursos/constantes.dart';
import '../../../componentes/campo_texto_detalhe.dart';

class LayoutDetalheTshirt extends StatelessWidget {
  LayoutDetalheTshirt({
    super.key,
    required this.corCampoTexto,
    required this.corProduto, required this.itemVenda, required this.c,
  }){
    if (itemVenda.detalheItem != null) {
      dizeresFrente = itemVenda.detalheItem!.frente!;
      dizeresTras = itemVenda.detalheItem!.tras!;
      tema = itemVenda.detalheItem!.tema!;
      corLetra = itemVenda.detalheItem!.corLetras!;
      corCampoTexto.value = Cores.paraColor(corLetra!);
    }
  }

  final Rx<Color> corCampoTexto;
  final Color corProduto;
  final MesaVendaC c;
  String dizeresFrente = "";
  String dizeresTras = "";
  String? tema;
  String? corLetra;
  final ItemVenda itemVenda;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      child: Column(
        children: [
          Container(height: 30,
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
                  itemVenda.detalheItem = DetalheItem(idItem: itemVenda.id, frente: dizeresFrente, tema: tema??"Critério do Designer", tras: dizeresTras, corLetras: corLetra??"Branca");
                  c.salvarDetalhe(itemVenda);
                  voltar();
                },
              ),
            ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${itemVenda.produto?.nome??"Produto Sem Nome"}"),
              SizedBox(width: 30,),
              Row(
                children: [
                  Text("Cor das Letras: "),
                  MenuDropDown(
                    labelMenuDropDown: itemVenda.detalheItem == null ? "Branca" :itemVenda.detalheItem!.corLetras!,
                    metodoChamadoNaInsersao: (dado) {
                      corCampoTexto.value = Cores.paraColor(dado);
                      corLetra = dado;
                    },
                    listaItens: Cores.paraListaCoresEmTexto(),
                  ),
                ],
              ),
              SizedBox(width: 30,),
              Row(
                children: [
                  Text("Tema: "),
                  FutureBuilder<List<Tema>>(
                    future: ProvedorNetTema().pegarListaTema(),
                    builder: (context, snapshot) {
                      if(snapshot.data == null){
                        return CircularProgressIndicator();
                      }
                      
                      return MenuDropDown(
                        labelMenuDropDown: itemVenda.detalheItem == null ? snapshot.data![0].tema??"Nenhum" : itemVenda.detalheItem!.tema??"Nenhum",
                        metodoChamadoNaInsersao: (dado) {
                          tema = dado;
                        },
                        listaItens: snapshot.data!.map((e) => e.tema??"Sem Nome").toList(),
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Divider(),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: corProduto == Colors.white ? Colors.black : null,
                  height: MediaQuery.of(context).size.height * .50,
                  width: MediaQuery.of(context).size.height * .50,
                  child: Stack(
                    children: [
                      WebsafeSvg.asset(
                        "lib/recursos/svg/tshirt_front.svg",
                        semanticsLabel: 'Acme Logo',
                        height: MediaQuery.of(context).size.height * .50,
                        width: MediaQuery.of(context).size.height * .50,
                        color: corProduto,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.height * .2,
                          child: Obx(() {
                              return CampoTextoDetalhe(aoDigitar: (valor) {
                                dizeresFrente = valor;
                              }, corCampoTexto: corCampoTexto.value, 
                              corTshirt: corProduto, quantidadeLinhas: 7,
                              texoPadrao: itemVenda.detalheItem == null ? null : itemVenda.detalheItem!.frente,);
                            }
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                width: 100,
              ),
              Container(
                color: corProduto == Colors.white ? Colors.black : null,
                  height: MediaQuery.of(context).size.height * .50,
                  width: MediaQuery.of(context).size.height * .50,
                  child: Stack(
                    children: [
                      WebsafeSvg.asset(
                        "lib/recursos/svg/tshirt_back.svg",
                        semanticsLabel: 'Acme Logo',
                        height: MediaQuery.of(context).size.height * .50,
                        width: MediaQuery.of(context).size.height * .50,
                        color: corProduto,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.height * .2,
                          child: Obx(() {
                              return CampoTextoDetalhe(aoDigitar: (valor) {
                                dizeresTras = valor;
                              }, corCampoTexto: corCampoTexto.value, 
                              corTshirt: corProduto, quantidadeLinhas: 7,
                              texoPadrao: itemVenda.detalheItem == null ? null : itemVenda.detalheItem!.tras,);
                            }
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          
            
        ],
      ),
    );
  }
}