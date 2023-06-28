import '../../dominio/entidades/detalhe_item.dart';
import '../../dominio/entidades/item_venda.dart';
import '../../dominio/entidades/tipo_detalhe.dart';

abstract class ProvedorDetalheItemI {
  Future<List<DetalheItem>> todos();
  Future<DetalheItem?> pegarDetalheItemDeId(int id);
  Future<bool> actualizaDetalheItem(DetalheItem dado);
  Future<int> registarDetalheItem(DetalheItem dado);
  Future<int> removerDetalheItem(DetalheItem dado);

  Future<int> registarTipoDetalhe(TipoDetalhe dado);
  Future<int> actualizarTipoDetalhe(TipoDetalhe dado);
  Future<int> removerTipoDetalhe(int idDado);
  Future<List<TipoDetalhe>> pegarListaTipoDetalhe();
  Future<TipoDetalhe?> pegarTipoDetalheDeId(int id);
}