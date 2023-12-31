import 'package:grafica_frontend/dominio/entidades/cliente.dart';
import 'package:grafica_frontend/dominio/entidades/divida.dart';
import 'package:grafica_frontend/dominio/entidades/pagamento.dart';
import 'package:grafica_frontend/dominio/entidades/venda.dart';

import '../../dominio/entidades/funcionario.dart';
import '../../dominio/entidades/item_venda.dart';

abstract class ManipularDividaI {
  Future<int> registarDivida(Divida divida);
  Future<List<Divida>> pegarListaTodasDividas();
  Future<bool> actualizarDivida(Divida divida);
  Future<bool> removerDivida(Divida divida);
  Future<bool> removerTodasDividas();

  removerAntes(DateTime dataSelecionada) {}
}
