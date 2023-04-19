import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(35, 87, 132, 1);
// const primaryColor = Color.fromRGBO(86, 0, 78, 1);
const branca = Colors.white;
const secondaryColor = Color(0xFF2A2D3E);
const backgroundColor = Color(0xFF212332);

const defaultPadding = 16.0;

const URL_BASE = "http://127.0.0.1:8000/api/";
String TOKEN_USUARIO_ATUAL = "SemToken";

const URL_LOGIN = "${URL_BASE}login";
const URL_CADASTRO_USUARIO = "${URL_BASE}registarUsuario";
const URL_ATUALIZAR_USUARIO = "${URL_BASE}atualizarUsuario";
const URL_ATUALIZAR_USUARIO_COM_PASS = "${URL_BASE}atualizarUsuarioComPass";
const URL_REMOVER_USUARIO = "${URL_BASE}eliminarUsuario";
const URL_TODOS_USUARIOS = "${URL_BASE}usuarios";
const URL_TERMINAR_SESSAO = "${URL_BASE}terminarSessao";

const URL_TODOS_FUNCIONARIOS = "${URL_BASE}funcionarios";
const URL_CADASTRO_FUNCIONARIO = "${URL_BASE}registarFuncionario";
const URL_ATUALIZAR_FUNCIONARIO = "${URL_BASE}atualizarFuncionario";
const URL_REMOVER_FUNCIONARIO = "${URL_BASE}eliminarFuncionario";

const URL_ADD_PRODUTO = "${URL_BASE}registarProduto";
const URL_TODOS_PRODUTO = "${URL_BASE}produtos";
const URL_REMOVER_PRODUTO = "${URL_BASE}eliminarProduto";
const URL_ATUALIZAR_PRODUTO = "${URL_BASE}atualizarProduto";

const URL_ADD_STOCK = "${URL_BASE}registarStock";
const URL_TODOS_STOCKS = "${URL_BASE}stocks";
const URL_REMOVER_STOCK = "${URL_BASE}eliminarStock";
const URL_ATUALIZAR_STOCK = "${URL_BASE}atualizarStock";

const URL_ADD_PRECO = "${URL_BASE}registarPreco";
const URL_TODOS_PRECOS = "${URL_BASE}precos";
const URL_REMOVER_PRECO = "${URL_BASE}eliminarPreco";
const URL_ATUALIZAR_PRECO = "${URL_BASE}atualizarPreco";

const URL_ADD_ENTRADA = "${URL_BASE}registarEntrada";
const URL_ATUALIZAR_ENTRADA = "${URL_BASE}atualizarEntrada";
const URL_TODOS_ENTRADAS = "${URL_BASE}entradas";
const URL_REMOVER_ENTRADA = "${URL_BASE}eliminarEntrada";

const URL_ADD_SAIDA = "${URL_BASE}registarSaida";
const URL_ATUALIZAR_SAIDA = "${URL_BASE}atualizarSaida";
const URL_TODOS_SAIDAS = "${URL_BASE}saidas";
const URL_REMOVER_SAIDA = "${URL_BASE}eliminarSaida";

const URL_ADD_CLIENTE = "${URL_BASE}registarCliente";
const URL_ATUALIZAR_CLIENTE = "${URL_BASE}atualizarCliente";
const URL_TODOS_CLIENTE = "${URL_BASE}clientes";
const URL_REMOVER_CLIENTE = "${URL_BASE}eliminarCliente";

const URL_ADD_PEDIDO = "${URL_BASE}registarPedido";
const URL_ATUALIZAR_PEDIDO = "${URL_BASE}atualizarPedido";
const URL_TODOS_PEDIDO = "${URL_BASE}pedidos";
const URL_REMOVER_PEDIDO = "${URL_BASE}eliminarPedido";

const URL_ADD_ITEM_PEDIDO = "${URL_BASE}registarItemPedido";
const URL_ATUALIZAR_ITEM_PEDIDO = "${URL_BASE}atualizarItemPedido";
const URL_TODOS_ITEM_PEDIDO = "${URL_BASE}itemsPedido";
const URL_REMOVER_ITEM_PEDIDO = "${URL_BASE}eliminarItemPedido";

const URL_ADD_PAGAMENTO = "${URL_BASE}registarPagamento";
const URL_ATUALIZAR_PAGAMENTO = "${URL_BASE}atualizarPagamento";
const URL_TODOS_PAGAMENTO = "${URL_BASE}pagamentos";
const URL_REMOVER_PAGAMENTO = "${URL_BASE}eliminarPagamento";

const URL_ADD_FORMA_PAGAMENTO = "${URL_BASE}registarFormaPagamento";
const URL_ATUALIZAR_FORMA_PAGAMENTO = "${URL_BASE}atualizarFormaPagamento";
const URL_TODOS_FORMA_PAGAMENTO = "${URL_BASE}formasPagamento";
const URL_REMOVER_FORMA_PAGAMENTO = "${URL_BASE}eliminarFormaPagamento";


class TipoNegocio {
  static const int GROSSO = 1, RETALHO = 2;
}

class TipoEntidade {
  static const int INDUSTRIAL = 1, COMERCIAL = 2, PRESTACAO_SERVICO = 3;
}