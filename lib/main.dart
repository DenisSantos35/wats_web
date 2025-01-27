import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wats_web/routes.dart';
import 'package:wats_web/utils/palete_colors.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: PaleteColors.primaryColor,
  appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: PaleteColors.primaryColor,
      titleTextStyle: TextStyle(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      toolbarTextStyle: TextStyle(color: Colors.white)),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyA3wv4IKQUp2qmGK4oRmmr-_eroyu-P1NE",
        appId: "1:854375271901:web:91ebc4c5986be57a6ffa34",
        messagingSenderId: "854375271901",
        projectId: "whatsappweb-bb27a"),
  );

  User? userFirebase = FirebaseAuth.instance.currentUser;
  String initialUrl = "/";
  if (userFirebase != null) {
    initialUrl = "/home";
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Chat",
    //home: Login(),
    theme: defaultTheme,
    initialRoute: initialUrl,
    onGenerateRoute: Routes.generateRoute,
  ));
}
