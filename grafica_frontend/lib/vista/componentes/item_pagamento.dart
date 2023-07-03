import 'package:componentes_visuais/componentes/icone_item.dart';
import 'package:flutter/material.dart';
import 'package:grafica_frontend/dominio/entidades/forma_pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/saida.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/pagamentos/pagamentos_c.dart';

import '../../recursos/constantes.dart';

class ItemPagamento extends StatelessWidget {
  final FormaPagamento formaPagamento;
  final PagamentosC c;
  ItemPagamento({
    Key? key,
    required this.formaPagamento,
    required this.c,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Forma de Pagamento: ${formaPagamento.forma ?? "Inválida"}"),
                Text(
                    "Tipo: ${Pagamento.paraTexto(formaPagamento.tipo??0)}"),
              ],
            ),
            Spacer(),
            IconeItem(
              titulo: "Eliminar",
              icone: Icons.delete,
              metodoQuandoItemClicado: () {
                c.mostrarDialogoEliminar(formaPagamento);
              },
              cor: primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
