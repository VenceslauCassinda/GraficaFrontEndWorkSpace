import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../recursos/constantes.dart';
import '../../../../../../../componentes/tab_bar.dart';
import '../vendas.dart';
import '../vendas_c.dart';

class LayoutEntidadeGrosso extends StatelessWidget {
  const LayoutEntidadeGrosso({
    Key? key,
    required this.data,
    required VendasC c,
  })  : _c = c,
        super(key: key);

  final DateTime data;
  final VendasC _c;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              Obx(
                () {
                  var total = _c.lista.length;
                  return Text(
                    "Encomendas ($total)",
                    style: TextStyle(color: primaryColor, fontSize: 20),
                  );
                }
              ),
              const Spacer(),
              Text(
                "${(data.day == DateTime.now().day && data.month == DateTime.now().month && data.year == DateTime.now().year) ? "HOJE" : "DATA"} - ${formatarMesOuDia(data.day)}/${formatarMesOuDia(data.month)}/${data.year}",
                style: const TextStyle(color: primaryColor, fontSize: 20),
              ),
            ],
          ),
        ),
        Obx(() {
            return Visibility(
              visible: _c.baixando.value == false,
              replacement: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(),
              ),
              child: Container(
                  height: MediaQuery.of(context).size.height * .6,
                  child: LayoutVendas(visaoGeral: false)),
            );
          }
        ),
      ],
    );
  }
}
