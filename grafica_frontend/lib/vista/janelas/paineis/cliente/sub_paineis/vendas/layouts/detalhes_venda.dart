import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/nivel_acesso.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/recursos/constantes.dart';
import 'package:grafica_frontend/vista/aplicacao_c.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../dominio/entidades/item_venda.dart';
import '../../../../../../../dominio/entidades/venda.dart';
import '../../../../../../../solucoes_uteis/console.dart';
import '../../../../../../../solucoes_uteis/formato_dado.dart';
import '../../../../../../componentes/item_item_venda.dart';
import 'vendas_c.dart';
import 'dart:js' as js;

class LayoutDetalhesVenda extends StatelessWidget {
  LayoutDetalhesVenda({
    Key? key,
    required this.venda,
  }) : super(key: key) {
    vendasC = Get.find();
  }
  final Venda venda;
  late VendasC vendasC;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .6,
      margin: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Detalhes da Encomenda",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.2)),
                  borderRadius: BorderRadius.circular(7)),
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 340,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total: ${venda.total}"),
                            Text("Total Pago: ${venda.parcela} KZ"),
                            Container(width: 200, child: const Divider()),
                            Visibility(
                              visible: venda.pagamentos != null,
                              replacement: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (venda.pagamentos ?? [])
                                    .map((element) => Text(
                                        "${formatar(element.valor ?? 0)} KZ - Pagamento: ${element.formaPagamento?.tipo ?? "[Não Definido]"}"))
                                    .toList(),
                              ),
                              child: FutureBuilder<List<Pagamento>>(
                                  future: vendasC.pegarPagamentosVenda(venda),
                                  builder: (c, s) {
                                    if (s.data == null) {
                                      return const CircularProgressIndicator();
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (s.data ?? []).map((element) {
                                        var text = Text(
                                            "${formatar(element.valor ?? 0)} KZ - Pagamento ${element.formaPagamento?.forma ?? "[Não Definido]"}");
                                        return InkWell(
                                          onTap: ()async {
                                            if (element.comprovativo?.arquivo != null) {
                                              mostrarDialogoDeLayou(Container(
                                                width: MediaQuery.of(context).size.width * .5,
                                                height: MediaQuery.of(context).size.height * .5,
                                                child: SfPdfViewer.memory(element.comprovativo!.arquivo!.bytes!),
                                              ));
                                              return;
                                            }
                                              var c = await vendasC.pegarComprovativoDoPagamentoDeId(element.id!);
                                              if (c == null) {
                                                mostrarDialogoDeInformacao("Sem Comprovativo!");
                                                return;
                                              }
                                              js.context.callMethod('open', ["$URL_STORAGE${c.link!}"]);
                                          },
                                          child: text);
                                      }).toList(),
                                    );
                                  }),
                            ),
                            Container(width: 200, child: const Divider()),
                            Visibility(
                              visible: venda.divida == true,
                              child: Text(
                                  "Por pagar: ${formatar((venda.total ?? 0) - (venda.parcela ?? 0))} KZ"),
                              replacement: const Row(
                                children: [
                                  Text("Paga"),
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: pegarAplicacaoC().pegarUsuarioActual()!.nivelAcesso != NivelAcesso.CLIENTE,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 200,
                                child: Text(
                                    "Cliente: ${venda.cliente?.nome ?? "Sem nome"}")),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                                "Telefone: ${venda.cliente?.numero ?? "Sem Número"}"),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: venda.itensVenda != null,
              replacement: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: venda.itensVenda!
                    .map((element) => ItemItemVenda(
                          element: element,
                          permissao: true,
                        ))
                    .toList(),
              ),
              child: FutureBuilder<List<ItemVenda>>(
                  future: vendasC.pegarItensVenda(venda),
                  builder: (c, s) {
                    if (s.data == null) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (s.data ?? [])
                          .map((element) => ItemItemVenda(
                                element: element,
                                aoVerPersonalizacoes: (){
                                  vendasC.verDetalhesItemVenda(element, context);
                                },
                                permissao: false,
                              ))
                          .toList(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
