import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/dominio/entidades/painel_actual.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import 'package:grafica_frontend/solucoes_uteis/formato_dado.dart';
import 'package:grafica_frontend/solucoes_uteis/responsividade.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/painel_funcionario_c.dart';

import '../../../../../../../recursos/constantes.dart';
import '../../../../../componentes/pesquisa.dart';
import 'layouts/grosso/layout_entidade_grosso.dart';
import 'layouts/retalho/mesa_vendas_retalho.dart';
import 'layouts/vendas_c.dart';

class PainelVendas extends StatelessWidget {
  PainelVendas({
    Key? key,
    required this.data,
    required this.permissao,
    required this.funcionario,
    this.accaoAoVoltar,
    this.aoTerminarSessao,
    this.funcionarioC,
  }) {
    initiC();
  }

  PainelFuncionarioC? funcionarioC;

  final bool permissao;
  Function? accaoAoVoltar;
  Function? aoTerminarSessao;
  late VendasC _c;
  final DateTime data;
  final Funcionario? funcionario;

  initiC() {
    try {
      _c = Get.find();
      _c.data = data;
      _c.funcionario = funcionario;
    } catch (e) {
      _c = Get.put(VendasC(data, funcionario));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: LayoutPesquisa(
              accaoNaInsercaoNoCampoTexto: (dado) {
                _c.aoPesquisarVenda(dado);
              },
              accaoAoSair: aoTerminarSessao,
              accaoAoVoltar: accaoAoVoltar),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                return Text(
                  "CAIXA: ${formatar(_c.totalCaixa.value)} KZ",
                  style: const TextStyle(color: primaryColor, fontSize: 15),
                );
              }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(
                () => Text(
                  "DÍVIDAS PAGAS: ${formatar(_c.totalDividaPagas.value)} KZ",
                  style: const TextStyle(color: primaryColor, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "DINHEIRO FÍSICO: ${formatar(_c.lista.fold<double>(0, (antigoV, cadaV) => ((cadaV.pagamentos ?? []).fold<double>(0, (antigoP, cadaP) {
                      if (cadaP.valor == null) {
                        return 0;
                      }
                      if ((cadaP.formaPagamento?.descricao ?? "")
                              .toLowerCase()
                              .contains('CASH'.toLowerCase()) ==
                          true) {
                        return (cadaP.valor ?? 0) + antigoP;
                      }
                      return antigoP;
                    }) + antigoV)))} KZ",
                style: const TextStyle(color: primaryColor, fontSize: 15),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "DINHEIRO DIGITAL: ${formatar(_c.lista.fold<double>(0, (antigoV, cadaV) => ((cadaV.pagamentos ?? []).fold<double>(0, (antigoP, cadaP) {
                      if (cadaP.valor == null) {
                        return 0;
                      }
                      if ((cadaP.formaPagamento?.descricao ?? "")
                              .toLowerCase()
                              .contains('CASH'.toLowerCase()) ==
                          false) {
                        mostrar(cadaP.formaPagamento?.descricao);
                        mostrar(cadaP.valor);
                        return (cadaP.valor ?? 0) + antigoP;
                      }
                      return antigoP;
                    }) + antigoV)))} KZ",
                style: const TextStyle(color: primaryColor, fontSize: 15),
              ),
            ),
          ],
        ),
        LayoutEntidadeGrosso(
          c: _c,
          data: data,
        ),
        Visibility(
          visible: !Responsidade.isMobile(context),
          replacement: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PopupAccoes(funcionarioC: funcionarioC, c: _c),
          ),
          child: LayoutAccoes(
              permissao: permissao, funcionarioC: funcionarioC, c: _c),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ModeloButao(
            corButao: primaryColor,
            corTitulo: Colors.white,
            butaoHabilitado: true,
            tituloButao: "Adicionar Venda",
            metodoChamadoNoClique: () {
              _c.mostrarDialogoNovaVenda(context);
            },
          ),
        )
      ],
    );
  }
}

class PopupAccoes extends StatelessWidget {
  const PopupAccoes({
    Key? key,
    required this.funcionarioC,
    required VendasC c,
  })  : _c = c,
        super(key: key);

  final PainelFuncionarioC? funcionarioC;
  final VendasC _c;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [Text("Ir Para"), Icon(Icons.arrow_drop_down)],
                ),
              ),
            ),
          ),
        ],
      ),
      onSelected: ((value) {
        if (value == 0) {
          funcionarioC?.irParaPainel(PainelActual.RECEPCOES);
          return;
        }
        if (value == 1) {
          _c.escolherData(context, funcionarioC!);
          return;
        }
      }),
      itemBuilder: ((context) {
        return [
          PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                Text("Recepções"),
                Spacer(),
                Icon(Icons.arrow_circle_down_outlined)
              ],
            ),
            onTap: () {},
          ),
          PopupMenuItem(
            value: 1,
            child: Row(
              children: [Text("Vendas"), Spacer(), Icon(Icons.store)],
            ),
          ),
        ];
      }),
    );
  }
}

class LayoutAccoes extends StatelessWidget {
  const LayoutAccoes({
    Key? key,
    required this.permissao,
    required this.funcionarioC,
    required VendasC c,
  })  : _c = c,
        super(key: key);

  final bool permissao;
  final PainelFuncionarioC? funcionarioC;
  final VendasC _c;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: permissao,
          child: Container(
            margin: const EdgeInsets.all(20),
            width: 200,
            child: ModeloButao(
              corButao: primaryColor,
              icone: Icons.arrow_circle_down,
              corTitulo: Colors.white,
              butaoHabilitado: true,
              tituloButao: "Recepções",
              metodoChamadoNoClique: () {
                funcionarioC?.irParaPainel(PainelActual.RECEPCOES);
              },
            ),
          ),
        ),
        Visibility(
          visible: permissao,
          child: Container(
            margin: const EdgeInsets.all(20),
            width: 200,
            child: ModeloButao(
              corButao: primaryColor,
              icone: Icons.store,
              corTitulo: Colors.white,
              butaoHabilitado: true,
              tituloButao: "Vendas",
              metodoChamadoNoClique: () {
                _c.escolherData(context, funcionarioC!);
              },
            ),
          ),
        ),
      ],
    );
  }
}
