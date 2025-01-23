import 'package:flutter/material.dart';
import 'package:wats_web/models/user.dart';
import 'package:wats_web/screens/home.dart';
import 'package:wats_web/screens/login.dart';

import 'screens/mensages.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/login":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/home":
        return MaterialPageRoute(builder: (_) => const Home());
      case "/mensages":
        return MaterialPageRoute(builder: (_) => Mensages(args as Users));
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
