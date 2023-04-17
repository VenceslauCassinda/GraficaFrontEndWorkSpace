import 'package:get/get.dart';
import 'package:grafica_frontend/dominio/entidades/cliente.dart';

import '../../contratos/provedores/provedor_cliente_i.dart';

class ProvedorCliente implements ProvedorClienteI {
  late var _dao;
  ProvedorCliente() {
  }
  @override
  Future<bool> actualizaCliente(Cliente dado) async {
    return await _dao.actualizarCliente(dado);
  }

  @override
  Future<int> adicionarCliente(Cliente dado) async {
    return await _dao.adicionarCliente(dado);
  }

  @override
  Future<Cliente?> pegarClienteDeId(int id) async {
    var res = await _dao.pegarClienteDeId(id);
    if (res != null) {
      return Cliente(estado: res.estado, nome: res.nome, numero: res.numero);
    }
    return null;
  }

  @override
  Future<void> removerCliente(Cliente dado) async {}

  @override
  Future<List<Cliente>> todos() async {
    return (await _dao.pegarClientes())
        .map((e) =>
            Cliente(estado: e.estado, nome: e.nome, numero: e.numero, id: e.id))
        .toList();
  }

  @override
  Future<int?> existeClientae(String nome, String numero) async {
    var res = await _dao.existeClienteDeNomeEnumero(nome, numero);
    return (res != null) ? res.id : -1;
  }

  @override
  Future<void> removerTudo() async {
    await _dao.removerTudo();
  }
  
  @override
  Future<bool> existeCliente(String nome, String numero) {
    // TODO: implement existeCliente
    throw UnimplementedError();
  }
}
