class NivelAcesso {
  static int FUNCIONARIO = 0;
  static int GERENTE = 1;
  static int ADMINISTRADOR = 2;
  static int CLIENTE = 3;
  static int DESIGNER = 4;
  static int SUPERVISOR = 5;

  static String paraTexto(int nivel) {
    if (nivel == FUNCIONARIO) {
      return "Funcionário";
    }
    if (nivel == GERENTE) {
      return "Gerente";
    }if (nivel == CLIENTE) {
      return "Cliente";
    }if (nivel == DESIGNER) {
      return "Designer";
    }if (nivel == SUPERVISOR) {
      return "Supervisor";
    }
    return "Administrador";
  }

  static int paraInteiro(String nivel) {
    if (nivel == "Funcionário") {
      return FUNCIONARIO;
    }
    if (nivel == "Gerente") {
      return GERENTE;
    }if (nivel == "Cliente") {
      return CLIENTE;
    }if (nivel == "Designer") {
      return DESIGNER;
    }if (nivel == "Supervisor") {
      return SUPERVISOR;
    }
    return ADMINISTRADOR;
  }
}
