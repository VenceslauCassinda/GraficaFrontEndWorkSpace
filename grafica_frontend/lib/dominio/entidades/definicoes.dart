import '../../recursos/constantes.dart';

class Definicoes {
  int? id;
  String? idLicenca;
  int? estado;
  int? tipoNegocio;
  int? tipoEntidade;
  DateTime? dataAcesso, dataExpiracao;
  String? licenca;
  bool? licenciado;

  Definicoes(
      {this.id,
      this.estado,
      this.tipoNegocio,
      this.idLicenca,
      this.licenciado,
      this.tipoEntidade,
      this.dataAcesso,
      this.dataExpiracao,
      this.licenca});

  static String tipoEntidadeParaTexto(int tipo) {
    if (tipo == TipoEntidade.COMERCIAL) {
      return "Comercial";
    }
    if (tipo == TipoEntidade.PRESTACAO_SERVICO) {
      return "Prestação de Serviço";
    }
    return "Industrial";
  }

  static int tipoEntidadeParaInteiro(String tipo) {
    if (tipo == "Comercial") {
      return TipoEntidade.COMERCIAL;
    }
    if (tipo == "Prestação de Serviço") {
      return TipoEntidade.PRESTACAO_SERVICO;
    }
    return TipoEntidade.INDUSTRIAL;
  }

  static String tipoNegocioParaTexto(int tipo) {
    if (tipo == TipoNegocio.GROSSO) {
      return "Venda à Grosso";
    }
    return "Venda à Retalho";
  }

  static int tipoNegocioParaInteiro(String tipo) {
    if (tipo == "Venda à Grosso") {
      return TipoNegocio.GROSSO;
    }
    return TipoNegocio.RETALHO;
  }

  
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'estado': estado,
      'licenciado': licenciado,
      'idLicenca': idLicenca,
      'licenca': licenca,
      'dataAcesso': dataAcesso,
      'dataExpiracao': dataExpiracao,
      'tipoNegocio': tipoNegocio,
      'tipoEntidade': tipoEntidade,
    };
  }
}
