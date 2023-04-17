import 'funcionario.dart';

class DinheiroSobra {
  Funcionario? funcionario;
  int? id;
  int? estado;
  int? idFuncionario;
  double? valor;
  DateTime? data;
  DinheiroSobra(
      {this.id,
      required this.estado,
      required this.idFuncionario,
      this.funcionario,
      required this.valor,
      required this.data});
  
}
