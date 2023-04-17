import 'package:get/get.dart' as g;
import 'package:grafica_frontend/dominio/entidades/item_venda.dart';
import 'package:grafica_frontend/dominio/entidades/produto.dart';
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
  bool get encomenda => (data != dataLevantamentoCompra);
  bool get venda => !divida;

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
  }
