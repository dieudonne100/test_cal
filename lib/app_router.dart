
import 'package:flutter/material.dart';
import 'package:test_call/calling_page.dart';
import 'package:test_call/home_page.dart';

class AppRoute {
  static const homePage = '/home_page';

  static const callingPage = '/calling_page';

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage(), settings: settings);
      case callingPage:
        return MaterialPageRoute(builder: (_) => CallingPage(), settings: settings);
      default:
        return null;
    }
  }
}