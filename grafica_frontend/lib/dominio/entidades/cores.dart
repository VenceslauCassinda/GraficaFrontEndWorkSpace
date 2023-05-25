import 'package:flutter/material.dart';

class Cores {

  static Color paraColor(String texto) {
    if (texto.toLowerCase().contains("preta")) {
      return Colors.black;
    }if (texto.toLowerCase().contains("azul")) {
      return Colors.blue;
    }if (texto.toLowerCase().contains("laranja")) {
      return Colors.orange;
    }if (texto.toLowerCase().contains("rosa")) {
      return Colors.pink;
    }if (texto.toLowerCase().contains("verde")) {
      return Colors.green;
    }if (texto.toLowerCase().contains("castanho")||texto.toLowerCase().contains("castanha")) {
      return Colors.brown;
    }if (texto.toLowerCase().contains("amarela")||texto.toLowerCase().contains("amarelo")) {
      return Colors.yellow;
    }if (texto.toLowerCase().contains("vermelho")||texto.toLowerCase().contains("vermelha")) {
      return Colors.red;
    }if (texto.toLowerCase().contains("cinzento")||texto.toLowerCase().contains("cinzenta")) {
      return Colors.grey;
    }
    return Colors.white;
  }
}
