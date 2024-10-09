import 'package:bill/bills_page.dart';
import 'package:bill/utils/notification_server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bill/utils/database.dart';

final NotificationServer _notificationServer = NotificationServer();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _notificationServer.checkForNotifications();
  showNotifications();
  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationServer>(create: (context) => NotificationServer()),
      ],
      child: const MyApp(),
    ),
  );
}

  showNotifications() async {
    bool fetchedBills = await getBillsAVencer();
    if (fetchedBills) {
      _notificationServer.showNotification(
        CustomNotification(
          id: 1,
          title: 'Contas a vencer',
          body: 'Acesse o app e descubra',
          payload: '/notifications'
        )
      );
    }
  }

class MyApp extends StatelessWidget {
  const MyApp(
    {
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bill',
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BillsPage(),
    );
  }
}

