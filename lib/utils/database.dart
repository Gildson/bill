import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Bills {
  final String descricaoBill;
  final int anoBill;
  final int mesBill;
  final String categoriaBill;
  final double valorBill;
  final int parcelaBill;
  final int qtdparcelasBill;
  final bool pagoBill;
  final String id;
  final bool unica;
  final bool sempre;
  final int vencimento;
  final DateTime dateCreated;

  Bills(
    this.descricaoBill,
    this.valorBill,
    this.parcelaBill,
    this.qtdparcelasBill,
    this.pagoBill,
    this.anoBill,
    this.mesBill,
    this.categoriaBill,
    this.id,
    this.unica,
    this.sempre,
    this.vencimento,
    this.dateCreated
  );
}

Future<void> loginBack4app() async {
  const keyApplicationId = 'uCSzdgaNxIwTkywrUmX83w0uCzXUSPglEUTR7Zlp';
  const keyClientKey = 'mxkZbUK3WOu7od07cUSO9qCTaZsYwItqjW3BKSiP';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
    clientKey: keyClientKey, debug: true);
}

Future<bool> getBillsAVencer() async {

  await loginBack4app();
  DateTime now = DateTime.now();
  int currentday = now.day;
  int currentMonth = now.month;
  int currentYear = now.year;
  var queryBuilder = QueryBuilder<ParseObject>(ParseObject('Contas'))
    ..whereEqualTo('emailUser', 'gildsonbsantos@gmail.com')
    ..whereEqualTo('Mes', currentMonth)
    ..whereEqualTo('Ano', currentYear)
    ..whereEqualTo('Pago', false)
    ..whereLessThanOrEqualTo('vencimento', currentday);
  var apiResponse = await queryBuilder.query();

  if (apiResponse.success && apiResponse.results != null) {
    if (apiResponse.results!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<List<Bills>?> getBills() async {
  List<Bills> bills = [];

  await loginBack4app();
  DateTime now = DateTime.now();
  int currentMonth = now.month;
  int currentYear = now.year;
  var queryBuilder = QueryBuilder<ParseObject>(ParseObject('Contas'))
    ..whereEqualTo('emailUser', 'gildsonbsantos@gmail.com')
    ..whereEqualTo('Mes', currentMonth)
    ..whereEqualTo('Ano', currentYear);
  var apiResponse = await queryBuilder.query();

  if (apiResponse.success && apiResponse.results != null) {
    for (var bill in apiResponse.results as List<ParseObject>) {
      bills.add(
        Bills(
          bill.get('Descricao'),
          bill.get('Valor').toDouble(),
          bill.get('parcela'),
          bill.get('Qtdparcelas'),
          bill.get('Pago'),
          bill.get('Ano'),
          bill.get('Mes'),
          bill.get('Categoria'),
          bill.get('objectId'),
          bill.get('unica'),
          bill.get('sempre'),
          bill.get('vencimento'),
          bill.get('createdAt')
        )
      );
    }
    return bills;
  } else {
    return null;
  }
}

Future<List<String>?> getCards() async {
  List<String> cards = [];

  await loginBack4app();
  var queryBuilder = QueryBuilder<ParseObject>(ParseObject('Cards'))
    ..whereEqualTo('emailUser', 'gildsonbsantos@gmail.com');
  var apiResponse = await queryBuilder.query();

  if (apiResponse.success && apiResponse.results != null) {
    for (var bill in apiResponse.results as List<ParseObject>) {
      cards.add(bill.get('NickName'));
    }
    return cards;
  } else {
    return null;
  }
}

Future<bool> deleteBill(String id) async {
  var bill = ParseObject('Contas')
  ..objectId = id;
  var response = await bill.delete();
  if (response.success) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteBills(String id, DateTime dateCreated, String descricao, double valor) async {
  var query = QueryBuilder<ParseObject>(ParseObject('Contas'))
    ..whereEqualTo('Descricao', descricao)
    ..whereEqualTo('Valor', valor)
    ..whereEqualTo('createdAt', dateCreated);

  var response = await query.query();

  if (response.success && response.results != null && response.results!.isNotEmpty) {
    bool allDeleted = true;
    for (ParseObject bill in response.results!) {
      logger.d(bill);
      var deleteResponse = await bill.delete();
      if (!deleteResponse.success) {
        allDeleted = false; // Se falhar ao deletar algum, marca como falha
      }
    }
    return allDeleted;
  } else {
    return false;
  }
}

Future<bool> addBill(
  int ano,
  double valor,
  String emailUser,
  String descricao,
  String categoria,
  int parcela,
  bool pago,
  int mes,
  int qtdparcelas,
  bool unica,
  bool sempre,
  int vencimento,
  String card
) async {
  var response;
  valor = valor/qtdparcelas;
  await loginBack4app();
  for (var i = parcela; i <= qtdparcelas; i++) {
    var bill = ParseObject('Contas')
      ..set('Ano', ano)
      ..set('Valor', valor)
      ..set('emailUser', emailUser)
      ..set('Descricao', descricao)
      ..set('Categoria', categoria)
      ..set('parcela', parcela)
      ..set('Pago', pago)
      ..set('Mes', mes)
      ..set('Qtdparcelas', qtdparcelas)
      ..set('unica', unica)
      ..set('sempre', sempre)
      ..set('vencimento', vencimento)
      ..set('Card', card);

    response = await bill.save();
    parcela++;
    mes++;
    if (mes > 12) {
      ano++;
      mes = 1;
    }
  }

  if (response.success) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateBill(List<dynamic> dados) async {
  var todo = ParseObject('Contas')
    ..objectId = dados[0]['Id']
    ..set('Ano', int.parse(dados[1]['Ano']))
    ..set('Descricao', dados[2]['Descricao'])
    ..set('Valor', double.parse(dados[3]['Valor']))
    ..set('parcela', int.parse(dados[4]['Parcela']))
    ..set('Qtdparcelas', int.parse(dados[5]['Qtdparcela']))
    ..set('Mes', int.parse(dados[6]['Mes']))
    ..set('Categoria', dados[7]['Categoria'])
    ..set('unica', dados[8]['unica'])
    ..set('sempre', dados[9]['sempre'])
    ..set('Card', dados[10]['card']);
  var response = await todo.save();
  if (response.success) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateBillPago(String id, bool pago) async {
  var todo = ParseObject('Contas')
    ..objectId = id
    ..set('Pago', pago);
  var response = await todo.save();
  if (response.success) {
    return true;
  } else {
    return false;
  }
}
