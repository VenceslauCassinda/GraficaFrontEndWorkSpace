import 'package:grafica_frontend/dominio/entidades/funcionario.dart';

class SaidaCaixa {
  int? id;
  int? estado;
  int? idFuncionario;
  DateTime? data;
  String? motivo;
  double? valor;

  Funcionario? funcionario;
  SaidaCaixa({
    this.id,
    required this.estado,
    required this.idFuncionario,
    required this.data,
    required this.motivo,
    this.funcionario,
    required this.valor,
  });
  }
