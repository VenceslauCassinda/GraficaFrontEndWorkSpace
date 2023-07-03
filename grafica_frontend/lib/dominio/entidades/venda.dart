import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:grafica_frontend/dominio/entidades/cores.dart';
import 'package:grafica_frontend/dominio/entidades/item_venda.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';
import 'package:grafica_frontend/solucoes_uteis/utils.dart';
import 'cliente.dart';
import 'funcionario.dart';
import 'pagamento.dart';
import 'preco.dart';

class Venda {
  Funcionario? funcionario;
  late Function accaoDestaque;
  bool vendaDestacada = false;
  Cliente? cliente;
  Produto? produto;
  List<Pagamento>? pagamentos = [];
  List<ItemVenda>? itensVenda = [];
  List<Preco>? precos = [];
  int? id;
  int? estado;
  int? quantidadeVendida;
  int? quantidade;
  int? idFuncionario;
  int? idProduto;
  int? idCliente;
  DateTime? data;
  DateTime? dataLevantamentoCompra;
  double? total;
  double? parcela;
  bool get divida => (total != parcela);
  bool get encomenda => comapararDatas(data!, dataLevantamentoCompra!) == false;
  bool get venda => (total == parcela);

  static int ESPERA = 0;
  static int RECEBIDO = 1;
  static int DESENHADO = 2;
  static int PRODUZIDO = 3;
  static int FINALIZADO = 4;

  var linhaPintada = false.obs;
  var linhaDestacada = false.obs;
  Venda(
      {this.id,
      this.funcionario,
      this.itensVenda,
      this.pagamentos,
      this.cliente,
      this.produto,
      required this.idProduto,
      required this.quantidadeVendida,
      required this.estado,
      required this.idFuncionario,
      required this.idCliente,
      required this.data,
      this.dataLevantamentoCompra,
      required this.total,
      required this.parcela});

  Venda.fromJson(Map json) {
    idFuncionario = json['id_funcionario'];
    idCliente = json['id_cliente'];
    total = json['total'];
    parcela = json['parcela'];
    estado = json['estado'];
    dataLevantamentoCompra = DateTime.parse(json['data_levantamento']);
    data = DateTime.parse(json['created_at']);
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_funcionario'] = idFuncionario;
    data['id_cliente'] = idCliente;
    data['total'] = total;
    data['parcela'] = parcela;
    data['estado'] = estado;
    data['data_levantamento'] = dataLevantamentoCompra;
    data['created_at'] = this.data;
    data['id'] = id;
    return data;
  }

  static String paraTexto(int nivel) {
    if (nivel == RECEBIDO) {
      return "Atendida";
    }
    if (nivel == DESENHADO) {
      return "Design";
    }
    if (nivel == ESPERA) {
      return "Não Atendida";
    }
    if (nivel == FINALIZADO) {
      return "Finalizada";
    }
    return "Produção";
  }

  static Color paraColor(int nivel) {
    if (nivel == ESPERA) {
      return Cores.paraColor("lilas");
    }
    if (nivel == RECEBIDO) {
      return Cores.paraColor("laranja");
    }
    if (nivel == DESENHADO) {
      return Cores.paraColor("azul");
    }if (nivel == PRODUZIDO) {
      return Cores.paraColor("amarela");
    }
    return Cores.paraColor("verde");
  }

  static int paraInteiro2(String nivel) {
    if (nivel == "Não Atendida") {
      return ESPERA;
    }
    if (nivel == "Design") {
      return DESENHADO;
    }
    if (nivel == "Atendida") {
      return RECEBIDO;
    }
    if (nivel == "Finalizada") {
      return FINALIZADO;
    }
    return PRODUZIDO;
  }

  static String paraTexto2(int nivel) {
    if (nivel == RECEBIDO) {
      return "Recepção (Atendida)";
    }
    if (nivel == DESENHADO) {
      return "Design";
    }
    if (nivel == ESPERA) {
      return "Recepção (Não Atendida)";
    }
    if (nivel == FINALIZADO) {
      return "Recepção (Finalizada)";
    }
    return "Produção";
  }

  static int paraInteiro(String nivel) {
    if (nivel == "Recepção (Não Atendida)") {
      return ESPERA;
    }
    if (nivel == "Design") {
      return DESENHADO;
    }
    if (nivel == "Recepção (Atendida)") {
      return RECEBIDO;
    }
    if (nivel == "Recepção (Finalizada)") {
      return FINALIZADO;
    }
    return PRODUZIDO;
  }
}
