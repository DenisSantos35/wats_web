import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wats_web/models/user.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _loggedUserId;

  Future<List<Users>> _recoverContacts() async {
    final userRef = _firestore.collection("users");
    QuerySnapshot querySnapshot = await userRef.get();
    List<Users> listUsers = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      String idUser = item["idUser"];
      if (idUser == _loggedUserId) continue;
      String name = item["name"];
      String email = item["email"];
      String urlImage = item["urlImage"];
      Uint8List imageBytes = base64Decode(urlImage);
      Users user = Users(idUser, name, email, imageByte: imageBytes);
      listUsers.add(user);
    }

    return listUsers;
  }

  _recoverLoggedInUserData() async {
    User? actualUser = await _auth.currentUser;
    if (actualUser != null) {
      _loggedUserId = actualUser.uid;
    }
  }

  @override
  void initState() {
    super.initState();
    _recoverLoggedInUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Users>>(
        future: _recoverContacts(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Column(
                  children: [
                    Text("Carregando contatos"),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Erro ao carregar os dados"),
                );
              } else {
                List<Users>? listUsers = snapshot.data;
                if (listUsers != null) {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.grey,
                        thickness: 0.2,
                      );
                    },
                    itemCount: listUsers.length,
                    itemBuilder: (context, index) {
                      Users user = listUsers[index];
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "/mensages",
                              arguments: user);
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: Image.memory(
                              user.imageByte!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        contentPadding: const EdgeInsets.all(8.0),
                      );
                    },
                  );
                }

                return const Center(
                  child: Text("Nenhum contato encontrado!"),
                );
              }
          }
        });
  }
}
