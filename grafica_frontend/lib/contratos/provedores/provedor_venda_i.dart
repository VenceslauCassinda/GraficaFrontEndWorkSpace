import 'package:grafica_frontend/dominio/entidades/funcionario.dart';

import '../../dominio/entidades/pagamento.dart';
import '../../dominio/entidades/venda.dart';

abstract class ProvedorVendaI {
  Future<List<Venda>> pegarLista(int idUsuario, DateTime data);
  Future<List<Venda>> pegarListaTodasDividas(int idUsuario);
  Future<List<Venda>> pegarListaTodasEncomendas(int idUsuario);
  Future<List<Pagamento>> pegarListaTodasPagamentoDividas(DateTime data);
  Future<List<Pagamento>> pegarListaTodasPagamentoDividasFuncionario(
      int idUsuario, DateTime data);
  Future<int> adicionarVenda(Venda venda);
  Future<int> removerVendaDeId(int id);
  Future<int> removerTodas();
  Future<Venda?> pegarVendaDeId(int id);
  Future<bool> actualizarVenda(Venda venda);
  Future<List<Venda>> pegarListaVendasFuncionario(int idUsuario);
  Future<List<Venda>> pegarListaVendas();
  Future<List<Venda>> todasDividas();
  Future<List<Venda>> todas();
  Future<List<Venda>> pegarListaTodasVendas();
}
