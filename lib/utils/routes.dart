import 'package:flutter/material.dart';
import 'package:bill/settings_page.dart';
import 'package:bill/bills_page.dart';
import 'package:bill/chart_page.dart';
import 'package:bill/notifications_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder> {
    '/bills': (_) => const BillsPage(),
    '/notifications': (_) => const NotificationsPage(),
    '/chart': (_) => const ChartPage(),
    '/settings': (_) => const SettingsPage()
  };

  static String initial = '/bills';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
