// import 'package:componentes_visuais/componentes/butoes.dart';
// import 'package:componentes_visuais/componentes/menu_drop_down.dart';
// import 'package:componentes_visuais/dialogo/dialogos.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:grafica_frontend/solucoes_uteis/console.dart';
// import 'package:grafica_frontend/vista/janelas/paineis/cliente/sub_paineis/vendas/layouts/grosso/mesa_venda/mesa_venda_c.dart';
// import 'package:websafe_svg/websafe_svg.dart';

// import '../../../../../../../dominio/entidades/cores.dart';
// import '../../../../../../../dominio/entidades/detalhe_item.dart';
// import '../../../../../../../dominio/entidades/evento.dart';
// import '../../../../../../../dominio/entidades/item_venda.dart';
// import '../../../../../../../dominio/entidades/tema.dart';
// import '../../../../../../../fonte_dados/provedores_net/provedor_net_evento.dart';
// import '../../../../../../../fonte_dados/provedores_net/provedor_net_tema.dart';
// import '../../../../../../../recursos/constantes.dart';
// import '../../../componentes/campo_texto_detalhe.dart';

// class LayoutDetalheTshirtAntigo extends StatelessWidget {
//   LayoutDetalheTshirtAntigo({
//     super.key,
//     required this.corCampoTexto,
//     required this.corProduto, required this.itemVenda, required this.c,
//   }){
//     if (itemVenda.detalheItem != null) {
//       dizeresFrente = itemVenda.detalheItem!.frente!;
//       dizeresTras = itemVenda.detalheItem!.tras!;
//       tema = itemVenda.detalheItem!.tema!;
//       evento = itemVenda.detalheItem!.evento!;
//       corLetra = itemVenda.detalheItem!.corLetras!;
//       corCampoTexto.value = Cores.paraColor(corLetra!);
//     }
//   }

//   final Rx<Color> corCampoTexto;
//   final Color corProduto;
//   final MesaVendaC c;
//   String dizeresFrente = "";
//   String dizeresTras = "";
//   String? tema;
//   String? evento;
//   String? corLetra;

//   var labelArquivo = "Seleccionar Arquivo".obs;
//   PlatformFile? arquivo;
//   final ItemVenda itemVenda;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * .8,
//       child: Column(
//         children: [
//           Container(height: 30,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.only(left: 20),
//                     child: ModeloButao(
//                       corButao: Colors.red,
//                       corTitulo: Colors.white,
//                       butaoHabilitado: true,
//                       tituloButao: "Cancelar",
//                       metodoChamadoNoClique: () {
//                         voltar();
//                       },
//                     ),
//                   ),
//                   Spacer(),
//                   Padding(
//               padding: const EdgeInsets.only(right: 20),
//               child: ModeloButao(
//                 corButao: primaryColor,
//                 corTitulo: Colors.white,
//                 butaoHabilitado: true,
//                 tituloButao: "Salvar",
//                 metodoChamadoNoClique: () {
//                   itemVenda.detalheItem = DetalheItem(idItem: itemVenda.id, frente: dizeresFrente, tema: tema??"Critério do Designer", tras: dizeresTras, corLetras: corLetra??"Branca", evento: evento,arquivo: arquivo);
//                   c.salvarDetalhe(itemVenda);
//                   voltar();
//                 },
//               ),
//             ),
//               ],
//             ),
//           ),
//           Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text("${itemVenda.produto?.nome??"Produto Sem Nome"}"),
//               SizedBox(width: 30,),
//               Row(
//                 children: [
//                   Text("Cor das Letras: "),
//                   MenuDropDown(
//                     labelMenuDropDown: itemVenda.detalheItem == null ? "Branca" :itemVenda.detalheItem!.corLetras!,
//                     metodoChamadoNaInsersao: (dado) {
//                       corCampoTexto.value = Cores.paraColor(dado);
//                       corLetra = dado;
//                     },
//                     listaItens: Cores.paraListaCoresEmTexto(),
//                   ),
//                 ],
//               ),
//               SizedBox(width: 30,),
//               Row(
//                 children: [
//                   Text("Tema: "),
//                   FutureBuilder<List<Tema>>(
//                     future: ProvedorNetTema().pegarListaTema(),
//                     builder: (context, snapshot) {
//                       if(snapshot.data == null){
//                         return CircularProgressIndicator();
//                       }
                      
//                       return MenuDropDown(
//                         labelMenuDropDown: itemVenda.detalheItem == null ? snapshot.data![0].tema??"Nenhum" : itemVenda.detalheItem!.tema??"Nenhum",
//                         metodoChamadoNaInsersao: (dado) {
//                           tema = dado;
//                         },
//                         listaItens: snapshot.data!.map((e) => e.tema??"Sem Nome").toList(),
//                       );
//                     }
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 30,),
//               Row(
//                 children: [
//                   const Text("Evento: "),
//                   FutureBuilder<List<Evento>>(
//                     future: ProvedorNetEvento().pegarListaEvento(),
//                     builder: (context, snapshot) {
//                       if(snapshot.data == null){
//                         return CircularProgressIndicator();
//                       }

//                       mostrar(snapshot.data);
                      
//                       return MenuDropDown(
//                         labelMenuDropDown: itemVenda.detalheItem == null ? snapshot.data![0].evento??"Nenhum" : itemVenda.detalheItem!.evento??"Nenhum",
//                         metodoChamadoNaInsersao: (dado) {
//                           evento = dado;
//                         },
//                         listaItens: snapshot.data!.map((e) => e.evento??"Sem Nome").toList(),
//                       );
//                     }
//                   ),
//                 ],
//               ),
//             ],
//           ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 5),
//                 child: Divider(),
//               ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 color: corProduto == Colors.white ? Colors.black : null,
//                   height: MediaQuery.of(context).size.height * .50,
//                   width: MediaQuery.of(context).size.height * .50,
//                   child: Stack(
//                     children: [
//                       WebsafeSvg.asset(
//                         "lib/recursos/svg/tshirt_front.svg",
//                         semanticsLabel: 'Acme Logo',
//                         height: MediaQuery.of(context).size.height * .50,
//                         width: MediaQuery.of(context).size.height * .50,
//                         color: corProduto,
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: SizedBox(
//                           width: MediaQuery.of(context).size.height * .2,
//                           child: Obx(() {
//                               return CampoTextoDetalhe(aoDigitar: (valor) {
//                                 dizeresFrente = valor;
//                               }, corCampoTexto: corCampoTexto.value, 
//                               corTshirt: corProduto, quantidadeLinhas: 7,
//                               texoPadrao: itemVenda.detalheItem == null ? null : itemVenda.detalheItem!.frente,);
//                             }
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),
//               SizedBox(
//                 width: 100,
//               ),
//               Container(
//                 color: corProduto == Colors.white ? Colors.black : null,
//                   height: MediaQuery.of(context).size.height * .50,
//                   width: MediaQuery.of(context).size.height * .50,
//                   child: Stack(
//                     children: [
//                       WebsafeSvg.asset(
//                         "lib/recursos/svg/tshirt_back.svg",
//                         semanticsLabel: 'Acme Logo',
//                         height: MediaQuery.of(context).size.height * .50,
//                         width: MediaQuery.of(context).size.height * .50,
//                         color: corProduto,
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: SizedBox(
//                           width: MediaQuery.of(context).size.height * .2,
//                           child: Obx(() {
//                               return CampoTextoDetalhe(aoDigitar: (valor) {
//                                 dizeresTras = valor;
//                               }, corCampoTexto: corCampoTexto.value, 
//                               corTshirt: corProduto, quantidadeLinhas: 7,
//                               texoPadrao: itemVenda.detalheItem == null ? null : itemVenda.detalheItem!.tras,);
//                             }
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),
//             ],
//           ),
          
//           Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Obx(() {
//                   return Text(labelArquivo.value);
//                 }),
//                 InkWell(
//                   onTap: () {
//                     selecionarArquivo();
//                   },
//                   child: const Icon(Icons.upload_file, size: 20),
//                 ),
//                 Obx(() {
//                   if (labelArquivo.value.contains("Seleccionar")) {
//                     return InkWell(
//                       child: const Text("Ver Foto"),
//                       onTap: () {
//                         mostrarDialogoDeLayou(Container(
//                           width: MediaQuery.of(context).size.height * .5,
//                           height: MediaQuery.of(context).size.height * .5,
//                           child: Image.memory(arquivo!.bytes!),
//                         ));
//                       },
//                     );
//                   }
//                   return Container();
//                 })
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   void selecionarArquivo() async {
//     var res = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ["png", "jpg", "jpeg"]
//     );
//     if (res == null) {
//       return;
//     }
//     PlatformFile arquivo = res.files.first;
//     labelArquivo.value = arquivo.name;
//     this.arquivo = arquivo;
//   }
// }