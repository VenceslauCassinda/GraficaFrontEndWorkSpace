import 'package:grafica_frontend/dominio/entidades/caixa.dart';
import 'package:grafica_frontend/dominio/entidades/invoice.dart';
import 'supplier.dart';

class Relatorio {
  final DateTime data;
  final String nomeEmpresa;
  final String nomeRelatorio;
  final String enderecoEmpresa;
  final String nifEmpresa;
  final Caixa caixa;
  final List<List<String>> listaItens;

  Relatorio(
      {required this.caixa,
      required this.nomeRelatorio,
      required this.data,
      required this.nomeEmpresa,
      required this.listaItens,
      required this.enderecoEmpresa,
      required this.nifEmpresa});

  Invoice toInvoice(DateTime data) {
    return Invoice(
      titulo: nomeRelatorio,
      supplier: Supplier(
        nif: "NIF: "+nifEmpresa,
        name: nomeEmpresa,
        address: enderecoEmpresa,
        paymentInfo: '',
      ),
      info: InvoiceInfo(
        date: data,
      ),
      items: listaItens.map((e) => InvoiceItem(e)).toList(),
    );
  }
}
