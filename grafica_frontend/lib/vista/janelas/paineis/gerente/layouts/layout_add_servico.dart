import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/label_erros.dart';
import 'package:componentes_visuais/componentes/menu_drop_down.dart';
import 'package:componentes_visuais/componentes/observadores/observador_butoes.dart';
import 'package:componentes_visuais/componentes/observadores/observador_campo_texto.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';
import 'package:grafica_frontend/vista/janelas/paineis/gerente/sub_paineis/servicos/painel_c.dart';

import '../../../../../dominio/entidades/tipo_produto.dart';
import '../../../../../recursos/constantes.dart';

class LayoutAddServico extends StatelessWidget {
  late ObservadorCampoTexto _observadorCampoTexto;
  late ObservadorButoes _observadorButoes = ObservadorButoes();

  final Function(String nome, int tipo) accaoAoFinalizar;

  Produto? produto;

  late String nome;
  int tipo = 0;
  late BuildContext context;

  LayoutAddServico({this.produto, required this.accaoAoFinalizar}) {
    _observadorCampoTexto = ObservadorCampoTexto();
    _observadorButoes = ObservadorButoes();

    if (produto != null) {
      nome = "${produto?.nome}";
      tipo = TipoProduto.paraInteiro(TipoProduto.paraTexto(produto?.tipo??0));
    } else {
      nome = "";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(100),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "DADOS DO SERVIÇO",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          CampoTexto(
            textoPadrao: nome,
            context: context,
            campoBordado: false,
            icone: Icon(Icons.text_fields),
            dicaParaCampo: "Nome do Serviço",
            metodoChamadoNaInsersao: (String valor) {
              nome = valor;
              _observadorCampoTexto.observarCampo(valor, TipoCampoTexto.nome);
              if (valor.isEmpty) {
                _observadorCampoTexto.mudarValorValido(
                    true, TipoCampoTexto.nome);
              }
              _observadorButoes.mudarValorFinalizarCadastroInstituicao([
                nome,
              ], [
                _observadorCampoTexto.valorNomeValido.value,
              ]);
            },
          ),
          Obx(() {
            return _observadorCampoTexto.valorNomeValido.value == true
                ? Container()
                : LabelErros(
                    sms: "Este Nome ainda é inválido!",
                  );
          }),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Aplicável para Produto do Tipo:  "),
                MenuDropDown(
                  labelMenuDropDown: TipoProduto.paraTexto(tipo),
                  metodoChamadoNaInsersao: (dado) {
                    tipo = TipoProduto.paraInteiro(dado);
                  },
                  listaItens: [
                    TipoProduto.paraTexto(0),
                    TipoProduto.paraTexto(1),
                    TipoProduto.paraTexto(2),
                    TipoProduto.paraTexto(3),
                    TipoProduto.paraTexto(4),
                    TipoProduto.paraTexto(5),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * .15,
                child: ModeloButao(
                  tituloButao: "Cancelar",
                  corButao: primaryColor,
                  corTitulo: Colors.white,
                  butaoHabilitado: true,
                  metodoChamadoNoClique: () async {
                    fecharDialogoCasoAberto();
                  },
                ),
              ),
              Obx(() {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width * .15,
                  child: ModeloButao(
                    corButao: Colors.white.withOpacity(.8),
                    butaoHabilitado: _observadorButoes
                        .butaoFinalizarCadastroInstituicao.value,
                    tituloButao: produto == null ? "Finalizar" : "Actualizar",
                    metodoChamadoNoClique: () {
                      accaoAoFinalizar(nome, tipo);
                    },
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
