import 'package:bill/chart_page.dart';
import 'package:bill/notifications_page.dart';
import 'package:bill/settings_page.dart';
import 'package:bill/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:bill/bill_insert_page.dart';
import 'package:bill/bill_update_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  List<Bills>? bills = [];
  bool isLoading = true;
  List<double> _offsets = [];
  Timer? _timer;
  late String _wordExcluir = '';
  bool deleteAll = false;
  
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission(); // Solicitar permissão ao iniciar
    loadBill();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela o timer quando a tela é destruída
    super.dispose();
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied || await Permission.notification.isPermanentlyDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> loadBill() async {
    setState(() {
      isLoading = true;
    });

    List<Bills>? fetchedBills = await getBills();

    setState(() {
      bills = fetchedBills;
      isLoading = false;
      try {
        _offsets = List.generate(bills!.length, (index) => 0.0);
      } catch (e) {
        _offsets = List.generate(10, (index) => 0.0);        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.black,
        backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
        title: const Text(
          'Contas',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: isLoading
        ? Center(
            child: Text(
              "Aguarde, carregando...",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
          )
        : (bills?.length != null)
        ? ListView.builder(
          itemCount: bills?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Transform.translate(
                offset: Offset(_offsets[index], 0.0), // Aplicar a translação ao Card
                child: Card(
                  color: const Color.fromRGBO(55, 55, 55, 1),
                  shadowColor: Colors.black,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              bottom: screenHeight * 0.001,
                              left: screenWidth * 0.025,
                              right: screenWidth * 0.03
                            ),
                            child: Text(
                              'Descrição',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                fontStyle: FontStyle.italic,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              bottom: screenHeight * 0.001,
                              left: screenWidth * 0.025,
                              right: screenWidth * 0.03
                            ),
                            child: Text(
                              bills![index].descricaoBill.toString().substring(0, bills![index].descricaoBill.toString().length > 10 ? 10 : bills![index].descricaoBill.toString().length),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ] 
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              bottom: screenHeight * 0.001,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02
                            ),
                            child: Text(
                              'Valor',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                fontStyle: FontStyle.italic,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              bottom: screenHeight * 0.001,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02
                            ),
                            child: Text(
                              NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(bills![index].valorBill),
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                        ] 
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              bottom: screenHeight * 0.001,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02
                            ),
                            child: Text(
                              'Par./QtdPar.',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                fontStyle: FontStyle.italic,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              bottom: screenHeight * 0.001,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02
                            ),
                            child: Text(
                              (bills![index].unica == true)
                              ? 'Única'
                              : (bills![index].sempre == true)
                              ? 'Sempre'
                              : '${bills![index].parcelaBill}/${bills![index].qtdparcelasBill}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                        ] 
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              bottom: screenHeight * 0.001,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02
                            ),
                            child: Text(
                              'Pago',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                fontStyle: FontStyle.italic,
                                color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              bottom: screenHeight * 0.001,
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02
                            ),
                            child: (bills![index].pagoBill == true)
                              ? Icon(
                                Icons.check,
                                size: screenWidth * 0.045,
                                color: Colors.white
                              )
                              : Icon(
                                Icons.clear,
                                size: screenWidth * 0.045,
                                color: Colors.white
                              ),
                          ),
                        ] 
                      ),
                    ]
                  )
                )
              ),
              onTap: () => onTap(
                bills![index].descricaoBill,
                bills![index].valorBill,
                bills![index].parcelaBill,
                bills![index].categoriaBill,
                bills![index].anoBill,
                bills![index].mesBill,
                bills![index].qtdparcelasBill,
                bills![index].id,
                bills![index].unica,
                bills![index].sempre,
                bills![index].vencimento
              ),
              onLongPress: () => _showPopupPagar(bills![index].id, bills![index].pagoBill),
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _offsets[index] += details.primaryDelta!;
                });
              },
              onHorizontalDragEnd: (details) {
                if (_offsets[index] > 100) {
                  _handleSwipeRight(bills![index].id, bills![index].dateCreated, bills![index].descricaoBill, bills![index].valorBill);
                } else if (_offsets[index] < -100) {
                  _handleSwipeLeft(bills![index].id, bills![index].dateCreated, bills![index].descricaoBill, bills![index].valorBill);
                }
                setState(() {
                  _offsets[index] = 0.0; // Resetar a posição do item
                });
              },
            );
          },
        )
        : Center(
          child: Text(
            "Você ainda não possui contas cadastradas.",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ), 
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 0, 255, 1),
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: 
            (context) => const BillInsertPage()
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BottomAppBar(
      color: const Color.fromRGBO(44, 44, 44, 1),
      padding: const EdgeInsets.only(
        left: 88.0,
        right: 88.0,
        top: 10,
        bottom: 10
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2
          ),
          borderRadius: BorderRadius.circular(30), // Adiciona bordas arredondadas
        ),
        padding: EdgeInsets.only(
          bottom: screenHeight * 0.001,
          top: screenHeight * 0.001,
          left: screenWidth * 0.01,
          right: screenWidth * 0.01
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1
                ),
                color: const Color.fromRGBO(0, 0, 255, 1),
                borderRadius: BorderRadius.circular(30), // Adiciona bordas arredondadas
              ),
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.001,
                top: screenHeight * 0.001,
                left: screenWidth * 0.025,
                right: screenWidth * 0.025
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: 
                      (context) => const NotificationsPage()
                    ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(0, 0, 255, 1),
                  backgroundColor: const Color.fromRGBO(0, 0, 255, 1),
                  shadowColor: Colors.black,
                  minimumSize: Size(screenWidth * 0.1, screenWidth * 0.08),
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.01,
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Icon(Icons.notifications, size: screenWidth * 0.07, color: Colors.white)
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1
                ),
                color: const Color.fromRGBO(0, 0, 255, 1),
                borderRadius: BorderRadius.circular(30), // Adiciona bordas arredondadas
              ),
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.001,
                top: screenHeight * 0.001,
                left: screenWidth * 0.025,
                right: screenWidth * 0.025
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: 
                      (context) => const ChartPage()
                    ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(0, 0, 255, 1),
                  backgroundColor: const Color.fromRGBO(0, 0, 255, 1),
                  shadowColor: Colors.black,
                  minimumSize: Size(screenWidth * 0.1, screenWidth * 0.08),
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.01,
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Icon(Icons.pie_chart, size: screenWidth * 0.07, color: Colors.white)
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1
                ),
                color: const Color.fromRGBO(0, 0, 255, 1),
                borderRadius: BorderRadius.circular(30), // Adiciona bordas arredondadas
              ),
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.001,
                top: screenHeight * 0.001,
                left: screenWidth * 0.025,
                right: screenWidth * 0.025
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: 
                      (context) => const SettingsPage()
                    ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(0, 0, 255, 1),
                  backgroundColor: const Color.fromRGBO(0, 0, 255, 1),
                  shadowColor: Colors.black,
                  minimumSize: Size(screenWidth * 0.1, screenWidth * 0.08),
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.01,
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.01,
                    right: screenWidth * 0.01
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Icon(Icons.settings, size: screenWidth * 0.07, color: Colors.white)
              ),
            )
          ],
        ),
      )
    );
  }

  void onTap(
    String bDescricao,
    double bValor,
    int bParcela,
    String bCategoria,
    int bAno,
    int bMes,
    int bQtdparcelas,
    String objecId,
    bool unica,
    bool sempre,
    int vencimento
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BillUpdatePage(
          ano: bAno,
          valor: bValor,
          emailUser: 'gildsonbsantos@gmail.com',
          descricao: bDescricao,
          parcela: bParcela,
          qtdparcelas: bQtdparcelas,
          categoria: bCategoria,
          mes: bMes,
          id: objecId,
          unica: unica,
          sempre: sempre,
          vencimento: vencimento,
        )
      )
    );
  }

  Future<void> _showPopupPagar(String id, bool pago) async {
    final screenWidth = MediaQuery.of(context).size.width;
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool done;
        return AlertDialog(
          title: Text(
            'Conta paga?',
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              fontFamily: 'Cresta', 
              fontWeight: FontWeight.normal              
              ),
              textAlign: TextAlign.center,
            ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Não',
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontFamily: 'Cresta', 
                      fontWeight: FontWeight.normal, 
                      color: Colors.black
                    ),
                  textAlign: TextAlign.start,
                  ),
                  onPressed: () async {
                    done = await updateBillPago(id, false);
                    if (done) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Ixe... Já já ela será paga.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontFamily: 'Cresta', 
                              fontWeight: FontWeight.normal,
                              color: Colors.white
                            ),
                          )
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: 
                          (context) => const BillsPage()
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Não foi possível atualizar.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontFamily: 'Cresta', 
                              fontWeight: FontWeight.normal,
                              color: Colors.white
                            ),
                          )
                        ),
                      );
                    }
                  },
                ),
                const Spacer(),
                TextButton(
                  child: Text(
                    'Sim',
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontFamily: 'Cresta', 
                      fontWeight: FontWeight.normal,
                      color: Colors.black
                    ),
                    textAlign: TextAlign.start,
                  ),
                  onPressed: () async => {
                    done = await updateBillPago(id, true),
                    if (done) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Uhuuu... mais uma conta paga.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontFamily: 'Cresta', 
                              fontWeight: FontWeight.normal,
                             color: Colors.white
                            ),
                          )
                        ),
                      ),
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: 
                          (context) => const BillsPage()
                        ),
                      )
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Não foi possível atualizar.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontFamily: 'Cresta', 
                              fontWeight: FontWeight.normal
                            ),
                          )
                        ),
                      )
                    }
                  } 
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _showPopupDeletar(String id, DateTime dateCreated, String Descricao, double Valor) async {
    final screenWidth = MediaQuery.of(context).size.width;
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool done;
        return AlertDialog(
          title: Text(
            _wordExcluir,
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              fontFamily: 'Cresta', 
              fontWeight: FontWeight.normal              
              ),
              textAlign: TextAlign.center,
            ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  child: Text(
                    'Não',
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontFamily: 'Cresta', 
                      fontWeight: FontWeight.normal,
                      color: Colors.black
                    ),
                  textAlign: TextAlign.start,
                  ),
                  onPressed: () => {
                    Navigator.pop(context)
                  },
                ),
                const Spacer(),
                TextButton(
                  child: Text(
                    'Sim',
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.normal,
                      color: Colors.black
                    ),
                    textAlign: TextAlign.start,
                  ),
                  onPressed: () async => {
                    done = (!deleteAll) ? await deleteBill(id) : await deleteBills(id, dateCreated, Descricao, Valor),
                    if (done) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            (!deleteAll) ? 'Conta excluída.' : 'Contas excluídas',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.normal,
                              color: Colors.white
                            ),
                          )
                        ),
                      ),
                      setState(() {
                        deleteAll = false;
                      }),
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: 
                          (context) => const BillsPage()
                        ),
                      )
                    } else {
                      setState(() {
                        deleteAll = false;
                      }),
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Não foi possível excluir.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.normal,
                              color: Colors.white
                            ),
                          )
                        ),
                      )
                    }
                  } 
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _handleSwipeRight(String id, DateTime dateCreated, String Descricao, double Valor) async {
    setState(() {
      _wordExcluir = 'Excluir conta?';
    });
    _showPopupDeletar(id, dateCreated, Descricao, Valor);
  }

  Future<void> _handleSwipeLeft(String id, DateTime dateCreated, String Descricao, double Valor) async {
    setState(() {
      _wordExcluir = 'Excluir todas as contas?';
      deleteAll = true;
    });
    _showPopupDeletar(id, dateCreated, Descricao, Valor);
  }
}
