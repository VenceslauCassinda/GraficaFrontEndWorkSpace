import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/label_erros.dart';
import 'package:componentes_visuais/componentes/menu_drop_down.dart';
import 'package:componentes_visuais/componentes/observadores/observador_butoes.dart';
import 'package:componentes_visuais/componentes/observadores/observador_campo_texto.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/saida.dart';

import '../../../../../../../recursos/constantes.dart';

class LayoutFormaPagamento extends StatelessWidget {
  late ObservadorCampoTexto _observadorCampoTexto;
  late ObservadorButoes _observadorButoes = ObservadorButoes();

  final Function(
          String valor, String? opcaoRetiradaSelecionada, PlatformFile arquivo)
      accaoAoFinalizar;

  String? valor;
  final String titulo;
  late BuildContext context;
  late String opcaoRetiradaSelecionada;
  var labelArquivo = "Seleccionar comprovativo".obs;
  final List<String> listaItens;
  PlatformFile? arquivo;

  LayoutFormaPagamento({
    required this.accaoAoFinalizar,
    required this.titulo,
    valor,
    required this.listaItens,
  }) {
    if (listaItens.isNotEmpty) {
      opcaoRetiradaSelecionada = listaItens[0];
    }else{
      opcaoRetiradaSelecionada = "Nenhuma";
    }
    _observadorCampoTexto = ObservadorCampoTexto();
    _observadorButoes = ObservadorButoes();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CampoTexto(
              textoPadrao: valor,
              context: context,
              campoBordado: false,
              icone: const Icon(Icons.lock),
              tipoCampoTexto: TipoCampoTexto.numero,
              dicaParaCampo: "Valor",
              metodoChamadoNaInsersao: (String novo) {
                valor = novo;
                _observadorCampoTexto.observarCampo(
                    novo, TipoCampoTexto.numero);
                if (novo.isEmpty) {
                  _observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.numero);
                }
                _observadorButoes.mudarValorFinalizarCadastroInstituicao([
                  valor ?? "",
                ], [
                  _observadorCampoTexto.valorNumeroValido.value,
                ]);
              },
            ),
            Obx(() {
              return _observadorCampoTexto.valorNumeroValido.value == true
                  ? Container()
                  : LabelErros(
                      sms: "Valor inválido!",
                    );
            }),
            const SizedBox(
              height: 20,
            ),
            Text(
              listaItens.isNotEmpty?titulo: "Sem Formas de Pagamento!",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Visibility(
              visible: listaItens.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MenuDropDown(
                  labelMenuDropDown: opcaoRetiradaSelecionada,
                  metodoChamadoNaInsersao: (dado) {
                    opcaoRetiradaSelecionada = dado;
                  },
                  listaItens: listaItens,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return Text(labelArquivo.value);
                }),
                InkWell(
                  onTap: () {
                    selecionarArquivo();
                  },
                  child: Icon(Icons.upload_file, size: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
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
                      tituloButao: "Finalizar",
                      metodoChamadoNoClique: () {
                        if (arquivo == null) {
                          mostrarDialogoDeInformacao(
                              "Nenhum ficheiro PDF seleccionado");
                          return;
                        }if (listaItens.isEmpty) {
                          mostrarDialogoDeInformacao(
                              "Não é possível continuar!\nContacte o SysAdm para adicionar novas formas de Pagamento!");
                          return;
                        }
                        accaoAoFinalizar(
                            valor!, opcaoRetiradaSelecionada, arquivo!);
                      },
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void selecionarArquivo() async {
    var res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"]
    );
    if (res == null) {
      return;
    }
    PlatformFile arquivo = res.files.first;
    labelArquivo.value = arquivo.name;
    this.arquivo = arquivo;
  }
}
