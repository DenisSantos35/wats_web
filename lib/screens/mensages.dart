import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wats_web/component/mensages_list.dart';
import 'package:wats_web/models/user.dart';

class Mensages extends StatefulWidget {
  final Users recipientUser;

  Mensages(this.recipientUser, {super.key});

  @override
  State<Mensages> createState() => _MensagesState();
}

class _MensagesState extends State<Mensages> {
  late Users _recipientUser;
  late Users _sendUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _recoverInitialData() async {
    _recipientUser = widget.recipientUser;

    User? loggedUser = _auth.currentUser;

    // var query = await _firestore
    //     .collection("users")
    //     .doc(loggedUser?.uid)
    //     .get()
    //     .then((_) {});

    if (loggedUser != null) {
      String idUser = loggedUser.uid;
      String? name = loggedUser.displayName ?? "";
      String? email = loggedUser.email ?? "";

      // String? buferImage = query.data()!["urlImage"].toString() ?? "";
      // Uint8List? imageBytes = base64Decode(buferImage);

      _sendUser = Users(idUser, name, email, urlImage: "");

      print(_sendUser);
    }
  }

  @override
  void initState() {
    super.initState();
    _recoverInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: ClipOval(
                child: Image.memory(
                  _recipientUser.imageByte!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              _recipientUser.name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: SafeArea(
        child: MensagesList(
          recipientUser: _recipientUser,
          sendUser: _sendUser,
        ),
      ),
    );
  }
}
