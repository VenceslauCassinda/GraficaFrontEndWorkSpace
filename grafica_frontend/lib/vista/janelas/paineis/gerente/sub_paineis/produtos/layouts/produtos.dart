import 'package:componentes_visuais/componentes/icone_item.dart';
import 'package:componentes_visuais/componentes/imagem_circulo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/produtos/layouts/produtos_c.dart';

import '../../../../../../../dominio/entidades/estado.dart';
import '../../../../../../../recursos/constantes.dart';
import '../../../../../../componentes/item_produto.dart';

class LayoutProdutos extends StatelessWidget {
  final List<Produto> lista;
  Function(Produto produto)? accaoAoClicarCadaProduto;
  ProdutosC? c;
  bool? permissao;
  LayoutProdutos({required this.lista, this.c, this.accaoAoClicarCadaProduto, this.permissao});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, indice) {
          return InkWell(
            onTap: () {
              if (accaoAoClicarCadaProduto != null) {
                accaoAoClicarCadaProduto!(lista[indice]);
              }
              return;
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: ItemProduto(
                produto: lista[indice],
                c: permissao == true ? c : null,
              ),
            ),
          );
        });
  }
}
