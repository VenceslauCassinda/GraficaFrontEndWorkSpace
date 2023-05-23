import 'package:grafica_frontend/dominio/entidades/estado.dart';
import 'package:grafica_frontend/dominio/entidades/nivel_acesso.dart';
import 'package:grafica_frontend/dominio/entidades/stock.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';

class Produto {
  Stock? stock;
  int? id;
  int? idPreco;
  int? estado;
  int? tipo;
  String? nome;
  double? precoCompra;
  bool? recebivel;
  // ATRIBUTOS PARA CALCULO EM INVENTARIO, INVESTIMENTO E ESTIMACOES
  int diferenca = 0;
  int quantidade = 0;
  int? quantidadeExistente;
  double vendaEstimado = 0;
  double lucroEstimado = 0;
  double lucro = 0;
  double precoGeral = -1;
  double dinheiro = 0;
  double investimento = 0;
  double? desperdicio;
  Produto(
      {this.id,
      this.estado,
      this.idPreco,
      this.stock,
      this.tipo,
      this.nome,
      this.precoCompra,
      this.recebivel});
  
  Produto.fromJson(Map json) {
    id = json['id'];
    nome = json['nome'];
    precoCompra = json['preco_compra'];
    estado = json['estado'];
    tipo = json['tipo'];
    recebivel = json['recebivel'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['preco_compra'] = this.precoCompra;
    data['estado'] = this.estado;
    data['tipo'] = this.tipo;
    data['recebivel'] = this.recebivel;
    return data;
  }
  
}

