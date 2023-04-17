import 'package:grafica_frontend/dominio/entidades/funcionario.dart';

import 'produto.dart';

class Receccao {
  int? id;
  int? estado;
  int? idFuncionario;
  int? idPagante;
  int? idProduto;
  int? quantidadePorLotes;
  int? quantidadeLotes;
  double? precoLote;
  double? custoAquisicao;
  bool? pagavel;
  bool? paga;
  DateTime? data;
  DateTime? dataPagamento;
  Funcionario? funcionario;
  Funcionario? pagante;
  Produto? produto;
  Receccao({
    this.id,
    this.funcionario,
    this.produto,
    required this.estado,
    required this.idFuncionario,
    this.idPagante,
    required this.idProduto,
    required this.pagavel,
    this.pagante,
    required this.paga,
    required this.quantidadePorLotes,
    required this.quantidadeLotes,
    required this.precoLote,
    required this.custoAquisicao,
    required this.data,
    this.dataPagamento,
  });

  int get quantidadeRecebida => (quantidadeLotes ?? 0) == 0
      ? (quantidadePorLotes ?? 0)
      : (quantidadeLotes ?? 0) * (quantidadePorLotes ?? 0);
  double get custoTotal => (quantidadeLotes ?? 0) == 0
      ? (quantidadePorLotes ?? 0) * (produto!.precoCompra ?? -1)
      : (quantidadeLotes ?? 0) * (precoLote ?? 0) + (custoAquisicao ?? 0);
  int get precoCompraProduto => custoTotal ~/ quantidadeRecebida;
  }
