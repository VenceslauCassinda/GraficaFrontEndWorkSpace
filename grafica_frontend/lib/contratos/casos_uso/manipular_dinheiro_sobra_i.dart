import 'package:grafica_frontend/dominio/entidades/dinheiro_sobra.dart';

abstract class ManipularDinheiroSobraI {
  Future<int> adicionarDinheiroSobra(DinheiroSobra dinheiroSobra);
  Future<bool> actualizarDinheiroSobra(DinheiroSobra dinheiroSobra);
  Future<int> removerDinheiroSobraDeId(int id);
  Future<int> removerTudo();
  Future<int> removerAntes(DateTime data);
  Future<List<DinheiroSobra>> pegarLista();
}
