import 'package:get/get.dart' as g;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_funcionario'] = this.idFuncionario;
    data['id_cliente'] = this.idCliente;
    data['total'] = this.total;
    data['parcela'] = this.parcela;
    data['estado'] = this.estado;
    data['data_levantamento'] = this.dataLevantamentoCompra;
    data['created_at'] = this.data;
    data['id'] = this.id;
    return data;
  }
  }
