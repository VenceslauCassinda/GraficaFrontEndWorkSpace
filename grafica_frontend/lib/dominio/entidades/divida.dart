import 'package:grafica_frontend/dominio/entidades/cliente.dart';
import 'package:grafica_frontend/dominio/entidades/funcionario.dart';

import 'produto.dart';

class Divida {
  int? id;
  int? idFuncionario;
  int? idFuncionarioPagante;
  int? idCliente;
  int? idProduto;
  int? estado;
  int? quantidadeDevida;
  DateTime? data;
  DateTime? dataPagamento;
  double? total;
  bool? paga;
  Funcionario? funcionario, funcionarioPagante;
  Cliente? cliente;
  Produto? produto;
  Divida(
      {this.id,
      required this.idFuncionario,
      this.idFuncionarioPagante,
      required this.idCliente,
      required this.idProduto,
      required this.estado,
      required this.quantidadeDevida,
      required this.data,
      this.dataPagamento,
      required this.total,
      required this.paga});
  
}
