import '../../dominio/entidades/detalhe_item.dart';
import '../../dominio/entidades/item_venda.dart';

abstract class ProvedorDetalheItemI {
  Future<List<DetalheItem>> todos();
  Future<DetalheItem?> pegarDetalheItemDeId(int id);
  Future<bool> actualizaDetalheItem(DetalheItem dado);
  Future<int> registarDetalheItem(DetalheItem dado);
  Future<int> removerDetalheItem(DetalheItem dado);
}