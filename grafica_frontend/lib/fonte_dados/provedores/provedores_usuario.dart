import 'package:get/get.dart';
import 'package:grafica_frontend/fonte_dados/erros.dart';
import 'package:grafica_frontend/fonte_dados/serializadores/serializador_usuario.dart';
import 'package:grafica_frontend/solucoes_uteis/console.dart';
import '../../contratos/provedores/provedor_usuario_i.dart';
import '../../dominio/entidades/usuario.dart';

class ProvedorUsuario implements ProvedorUsuarioI {
  late var _usuarioDao;
  late SerializadorUsuario _serializadorUsuario;

  ProvedorUsuario() {
    _serializadorUsuario = SerializadorUsuario();
  }

  @override
  Future<void> actualizarUsuario(Usuario usuario) async {
    await _usuarioDao.actualizar(_serializadorUsuario.toTabela(usuario));
  }

  @override
  Future<int> adicionarUsuario(Usuario usuario) async {
    if (await existeUsuarioComNomeUsuario(usuario.nomeUsuario!)) {
      throw ErroUsuarioJaExiste("NOME DE USUARIO JA EXISTENTE!");
    }
    return await _usuarioDao
        .adicionar(_serializadorUsuario.toCompanion(usuario));
  }

  @override
  Future<List<Usuario>> pegarLista() async {
    return (await _usuarioDao.todos())
        .map((e) => _serializadorUsuario.fromTabela(e))
        .toList();
  }

  @override
  Future<void> removerUsuario(Usuario usuario) async {
    await _usuarioDao.remover(usuario.id!);
  }

  @override
  Future<bool> existeUsuarioComNomeUsuario(String nomeUsuario) async {
    return await _usuarioDao.existeNomeUsuario(nomeUsuario);
  }

  @override
  Future<Usuario?> fazerLogin(String nomeUsuario, String palavraPasse) async {
    mostrar(nomeUsuario);
    nomeUsuario = nomeUsuario.toLowerCase();
    mostrar(nomeUsuario);
    var dado = await _usuarioDao.existeUsuario(nomeUsuario, palavraPasse);
    if (dado == null) {
      throw ErroUsuarioNaoExiste("CREDENCIAIS INVALIDAS");
    }
    // if ((await _usuarioDao.usuarioLogado(nomeUsuario)) == true) {
    //   throw ErroUsuarioJaLogado("USUARIO JA LOGADO");
    // }
    await _usuarioDao.logarUsuario(nomeUsuario, palavraPasse);
    return _serializadorUsuario
        .fromTabela((await _usuarioDao.pegarUsuario(nomeUsuario)));
  }

  @override
  Future<void> terminarSessao(Usuario usuario) async {
    if ((await _usuarioDao.usuarioLogado(usuario.nomeUsuario!)) == true) {
      await _usuarioDao.terminarSessao(
          usuario.nomeUsuario!, usuario.palavraPasse!);
      return;
    }
    throw ErroUsuarioNaoLogado("USUARIO NAO LOGADO");
  }

  @override
  Future<List<Usuario>> pegarListaEliminados() async {
    return (await _usuarioDao.eliminados())
        .map((e) => _serializadorUsuario.fromTabela(e))
        .toList();
  }
  
  @override
  Future<Usuario?> pegarUsuario(int id) {
    // TODO: implement pegarUsuario
    throw UnimplementedError();
  }

}
