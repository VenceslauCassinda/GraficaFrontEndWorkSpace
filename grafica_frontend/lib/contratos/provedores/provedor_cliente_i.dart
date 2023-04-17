import 'package:grafica_frontend/dominio/entidades/cliente.dart';

abstract class ProvedorClienteI {
  Future<List<Cliente>> todos();
  Future<Cliente?> pegarClienteDeId(int id);
  Future<bool> existeCliente(String nome, String numero);
  Future<bool> actualizaCliente(Cliente dado);
  Future<int> adicionarCliente(Cliente dado);
  Future<void> removerCliente(Cliente dado);
  Future<void> removerTudo();
}
