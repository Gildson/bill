import 'package:flutter/material.dart';
import 'package:bill/bills_page.dart';
import 'package:bill/chart_page.dart';
import 'package:bill/settings_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
        title: const Text(
          'Notificações',
          style: TextStyle(
            fontFamily: 'Cresta',
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: Center(
        child: Text(
          "Aguarde, estamos em processo de construção...",
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            color: Colors.white
          ),
          textAlign: TextAlign.center,
        ),
      )
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
                      (context) => const BillsPage()
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
                child: Icon(Icons.ballot_outlined, size: screenWidth * 0.07, color: Colors.white)
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
}