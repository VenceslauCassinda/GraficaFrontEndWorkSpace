class Filtros {
  static int PRODUTO = 0;
  static int DATA_L = 1;
  static int DATA_V = 2;
  static int CLIENTE = 3;
  static int PRECO = 4;
  static int DIVIDA = 5;
  static int QUANTIDADE = 6;

  static int paraInteiro(String nivel) {
    if (nivel == "Produto") {
      return PRODUTO;
    }
    if (nivel == "Data de Levantamento") {
      return DATA_L;
    }
    if (nivel == "Data de Venda") {
      return DATA_V;
    }
    if (nivel == "Cliente") {
      return CLIENTE;
    }if (nivel == "Preço") {
      return PRECO;
    }if (nivel == "Dívida") {
      return DIVIDA;
    }
    return QUANTIDADE;
  }

  static String paraTexto2(int nivel) {
    if (nivel == PRODUTO) {
      return "Produto";
    }
    if (nivel == DATA_L) {
      return "Data de Levantamento";
    }
    if (nivel == DATA_V) {
      return "Data de Venda";
    }
    if (nivel == CLIENTE) {
      return "Cliente";
    }if (nivel == PRECO) {
      return "Preço";
    }if (nivel == DIVIDA) {
      return "Dívida";
    }
    return "Quantidade";
  }
}