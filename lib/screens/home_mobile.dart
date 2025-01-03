import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("WhatsApp"),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              const SizedBox(width: 3.0),
              IconButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  icon: const Icon(Icons.logout)),
            ],
            bottom: const TabBar(
                unselectedLabelColor: Colors.white,
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                labelStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    text: "Conversas",
                  ),
                  Tab(text: "Contatos"),
                ]),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                Center(
                  child: Text("Conversas"),
                ),
                Center(
                  child: Text("Contatos"),
                ),
              ],
            ),
          ),
        ));
  }
}