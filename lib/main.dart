import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wats_web/routes.dart';
import 'package:wats_web/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyA3wv4IKQUp2qmGK4oRmmr-_eroyu-P1NE",
        appId: "1:854375271901:web:91ebc4c5986be57a6ffa34",
        messagingSenderId: "854375271901",
        projectId: "whatsappweb-bb27a"),
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "WhatsApp Web",
    //home: Login(),
    initialRoute: "/",
    onGenerateRoute: Routes.generateRoute,
  ));
}
