// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';
import 'package:grafica_frontend/dominio/entidades/nivel_acesso.dart';
import 'package:grafica_frontend/dominio/entidades/painel_actual.dart';
import 'package:grafica_frontend/solucoes_uteis/responsividade.dart';
import 'package:grafica_frontend/solucoes_uteis/utils.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/dinheiro_sobra/painel.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/saida_caixa/painel.dart';
import 'package:grafica_frontend/vista/janelas/paineis/funcionario/sub_paineis/vendas/painel_vendas.dart';
import '../../../../recursos/constantes.dart';
import '../gerente/sub_paineis/clientes/painel.dart';
import 'componentes/gaveta.dart';
import 'painel_funcionario_c.dart';
import 'sub_paineis/dividas_encomendas_gerais/painel.dart';

class PainelFuncionario extends StatelessWidget {
  late PainelFuncionarioC _c;
  PainelFuncionario({
    Key? key,
  }) : super(key: key) {
    initiC();
  }

  initiC() {
    try {
      _c = Get.find();
    } catch (e) {
      _c = Get.put(PainelFuncionarioC());
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(context);
    return ResponsiveLayoutBuilder(builder: (context, size) {
      Get.put(size);
      return Scaffold(
        drawer: !Responsidade.isDesktop(context)
            ? Container(
                color: branca,
                width: MediaQuery.of(context).size.width * .2,
                child: GavetaNavegacao(
                  linkImagem: "",
                  c: _c,
                ),
              )
            : null,
        appBar: !Responsidade.isDesktop(context)
            ? AppBar(
                backgroundColor: primaryColor,
              )
            : null,
        body: !Responsidade.isDesktop(context)
            ? pegarLayoutPainelAtual()
            : Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: GavetaNavegacao(
                        linkImagem: "",
                        c: _c,
                      )),
                  Expanded(
                    flex: 5,
                    child: pegarLayoutPainelAtual(),
                  ),
                ],
              ),
      );
    });
  }

  pegarLayoutPainelAtual() {
    return Obx( () {
      _c.painelActual.value.indicadorPainel;
        return FutureBuilder<Funcionario>(
            future: _c.inicializarFuncionario(),
            builder: (c, s) {
              if (_c.painelActual.value.indicadorPainel ==
                  PainelActual.VENDAS_FUNCIONARIOS) {
                return PainelVendas(
                  funcionarioC: _c,
                  permissao: (_c.funcionarioActual!).nivelAcesso ==
                          NivelAcesso.FUNCIONARIO &&
                      comapararDatas(DateTime.now(),
                          _c.painelActual.value.valor![1] as DateTime),
                  data: _c.painelActual.value.valor![1] as DateTime,
                  funcionario: _c.painelActual.value.valor![0] as Funcionario,
                  accaoAoVoltar: () {
                    _c.irParaPainel(PainelActual.INICIO);
                  },
                );
              }
              if (_c.painelActual.value.indicadorPainel ==
                      PainelActual.DIVIDAS_GERAIS ||
                  _c.painelActual.value.indicadorPainel ==
                      PainelActual.ENCOMENDAS_GERAIS) {
                return PainelDividas(
                  funcionario: _c.funcionarioActual!,
                  accaoAoVoltar: () {
                    _c.irParaPainel(PainelActual.INICIO);
                  },
                );
              }
              if (_c.painelActual.value.indicadorPainel ==
                  PainelActual.DINHEIRO_SOBRA) {
                return PainelDinheiroSobra(
                  funcionario: _c.funcionarioActual!,
                  c: _c,
                );
              }
              if (_c.painelActual.value.indicadorPainel ==
                  PainelActual.SAIDA_CAIXA) {
                return PainelSaidaCaixa(
                  _c,
                  _c.funcionarioActual!,
                );
              }
              if (_c.painelActual.value.indicadorPainel == PainelActual.CLIENTES) {
                return PainelClientes(
                  _c,
                  _c.funcionarioActual!,
                  accaoAoVoltar: () {
                    _c.irParaPainel(PainelActual.FUNCIONARIOS);
                  },
                );
              }
              return PainelVendas(
                data: DateTime.now(),
                funcionario: _c.funcionarioActual!,
                funcionarioC: _c,
                permissao:
                    (_c.funcionarioActual!).nivelAcesso == NivelAcesso.FUNCIONARIO,
                aoTerminarSessao: () {
                  _c.terminarSessao();
                },
              );
            });
      }
    );
  }
}
