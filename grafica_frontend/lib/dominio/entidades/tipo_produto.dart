class TipoProduto {
  static int SIMPLES = 0;
  static int TSHIRT = 1;
  static int CAPUZ = 2;
  static int CHAVENA = 3;
  static int CARIMBO = 4;
  static int BLOCO_FATURA = 5;

  static String paraTexto(int id) {
    if (id == TSHIRT) {
      return "T-Shirt";
    }
    if (id == CAPUZ) {
      return "Capuz";
    }
    if (id == CHAVENA) {
      return "Chávena";
    }
    if (id == CARIMBO) {
      return "Carimbo";
    }
    if (id == BLOCO_FATURA) {
      return "Bloco de Factura";
    }
    return "Simples";
  }

  static int paraInteiro(String id) {
    if (id == "T-Shirt") {
      return TSHIRT;
    }
    if (id == "Capuz") {
      return CAPUZ;
    }
    if (id == "Chávena") {
      return CHAVENA;
    }
    if (id == "Carimbo") {
      return CARIMBO;
    }
    if (id == "Bloco de Factura") {
      return BLOCO_FATURA;
    }
    return SIMPLES;
  }
}
