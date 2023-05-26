import 'package:flutter/material.dart';

class CampoTextoDetalhe extends StatelessWidget {
  CampoTextoDetalhe({
    super.key,
    required this.aoDigitar,
    required this.corCampoTexto,
    required this.corTshirt, required this.quantidadeLinhas, this.texoPadrao,
  });

  final Function(String valor) aoDigitar;
  final Color corCampoTexto;
  final Color corTshirt;
  final int quantidadeLinhas;
  String? texoPadrao;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: texoPadrao == null ? null : TextEditingController(text: texoPadrao),
      minLines: quantidadeLinhas,
      maxLines: quantidadeLinhas,
      onChanged: (value) => aoDigitar(value),
      style: TextStyle(color: corCampoTexto),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "Insira aqui os dizeres!",
        hintStyle: TextStyle(color: corCampoTexto,),
        focusColor: corCampoTexto,
        fillColor: corCampoTexto,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: corTshirt),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: corCampoTexto),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: corCampoTexto),
            borderRadius: BorderRadius.all(
          Radius.circular(20),
        )),
      ),
    );
  }
}
