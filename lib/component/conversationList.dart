import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wats_web/models/user.dart';

class Conversationlist extends StatefulWidget {
  const Conversationlist({super.key});

  @override
  State<Conversationlist> createState() => _ConversationlistState();
}

class _ConversationlistState extends State<Conversationlist> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Users _sendUser;
  StreamController _streamController =
      StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription _streamConversations;

  _conversationListenerAdd() {
    //firebase firestore retorna um Stream<QuerySnapshot> atraves do .snapshot();
    final stream = _firestore
        .collection("conversations")
        .doc(_sendUser.idUser)
        .collection("last_mensage")
        .snapshots();
    // toda e quaquer mudança no firebase e notificado e passado para o stream controller
    //que fica ouvindo as alterações.
    _streamConversations = stream.listen((data) {
      _streamController.add(data);
    });
  }

  Future<void> _recoverInitialData() async {
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
      _conversationListenerAdd();
    }
  }

  @override
  void initState() {
    super.initState();
    _recoverInitialData();
  }

  @override
  void dispose() {
    super.dispose();
    _streamConversations.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando conversas"),
                    CircularProgressIndicator()
                  ],
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erro ao carregar dados"),
                );
              } else {
                QuerySnapshot querySnapshot = snapshot.data;
                List<DocumentSnapshot> conversationList =
                    querySnapshot.docs.toList();
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    );
                  },
                  itemCount: conversationList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot conversation = conversationList[index];
                    String recipientImageUrl =
                        conversation["recipientImageUrl"];
                    String recipentName = conversation["recipentName"];
                    String lastMensage = conversation["lastMensage"];
                    String recipientId = conversation["recipientId"];
                    String recipientEmail = conversation["recipientEmail"];

                    String? buferImage = recipientImageUrl;
                    Uint8List? imageBytes = base64Decode(buferImage);

                    Users user = Users(
                        recipientId, recipentName, recipientEmail,
                        urlImage: recipientImageUrl, imageByte: imageBytes);

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
                      subtitle: Text(
                        lastMensage,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                    );
                  },
                );
              }
          }
        });
  }
}
