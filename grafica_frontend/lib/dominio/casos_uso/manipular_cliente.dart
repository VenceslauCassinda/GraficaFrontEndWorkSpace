import 'dart:math';

import 'package:grafica_frontend/contratos/casos_uso/manipular_usuario_i.dart';
import 'package:grafica_frontend/dominio/entidades/cliente.dart';
import 'package:grafica_frontend/dominio/entidades/nivel_acesso.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';

import '../../contratos/casos_uso/manipular_cliente_I.dart';
import '../../contratos/provedores/provedor_cliente_i.dart';
import '../entidades/usuario.dart';

class ManipularCliente implements ManipularClienteI {
  final ProvedorClienteI _provedorClienteI;
  ManipularUsuarioI? manipularUsuarioI;

  ManipularCliente(this._provedorClienteI,{this.manipularUsuarioI});
  @override
  Future<bool> actualizaCliente(Cliente dado) async {
    return await _provedorClienteI.actualizaCliente(dado);
  }

  @override
  Future<int> registarCliente(Cliente dado) async {
    var teste = await existeCliente(dado.nome!, dado.numero??"");
    if (teste <=0) {
      teste = await _provedorClienteI.adicionarCliente(dado);
    }
    return teste;
  }

  @override
  Future<Cliente?> pegarClienteDeId(int id) async {
    return await _provedorClienteI.pegarClienteDeId(id);
  }

  @override
  Future<void> removerCliente(Cliente dado) async {
    await _provedorClienteI.removerCliente(dado);
  }

  @override
  Future<List<Cliente>> todos() async {
    return await _provedorClienteI.todos();
  }

  @override
  Future<int> existeCliente(String nome, String numero) async {
    return (await _provedorClienteI.existeCliente(nome, numero)) == true ? 1:0;
  }

  @override
  Future<void> removerTudo() async {
    await _provedorClienteI.removerTudo();
  }

  @override
  removerAntes(DateTime dataSelecionada) async {
    var res = await todos();
  }
  
  @override
  Future<Cliente> registarClienteComUsuario(Cliente dado)async {
    String nomeUsuario;
    if (dado.nome!.contains(" ")) {
      nomeUsuario = dado.nome!.split(" ")[0];
    } else {
      nomeUsuario = dado.nome!;
    }
    nomeUsuario = nomeUsuario.toLowerCase();
    if ((await manipularUsuarioI!.existeNomeUsuario(nomeUsuario)) == true) {
      String acrescimoId =
          "${Random().nextInt(10)}${Random().nextInt(10)}${Random().nextInt(10)}${Random().nextInt(10)}";
      nomeUsuario = "${nomeUsuario.toLowerCase()}$acrescimoId";
    }
    dado.nomeUsuario = nomeUsuario;
    var novoUsuario = Usuario.registo(nomeUsuario, dado.palavraPasse);
    novoUsuario.nivelAcesso = NivelAcesso.CLIENTE;
    novoUsuario.palavraPasse = dado.palavraPasse;
    var idCliente = await registarCliente(dado);
    var id = await manipularUsuarioI!.registarUsuario(novoUsuario);
    dado.idUsuario = id;
    dado.id = idCliente;
    novoUsuario.id = id;
    dado.usuario = novoUsuario;
    return dado;
  }
}
