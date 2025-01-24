import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wats_web/models/user.dart';
import 'package:wats_web/utils/palete_colors.dart';

import '../models/mensage.dart';

class MensagesList extends StatefulWidget {
  final Users sendUser;
  final Users recipientUser;

  const MensagesList(
      {super.key, required this.sendUser, required this.recipientUser});

  @override
  State<MensagesList> createState() => _MensagesListState();
}

class _MensagesListState extends State<MensagesList> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _mensageController = TextEditingController();
  late Users _recipientUser;
  late Users _sendUser;

  //ficara ouvindo  para alterar os dados a cada nova mensagem
  StreamController _streamController =
      StreamController<QuerySnapshot>.broadcast();
  //quando sair da conversa ele cancelara o ouvinte.
  late StreamSubscription _streamMensages;

  _sendMensage() {
    String mensageText = _mensageController.text;

    String sendUserId = _sendUser.idUser;
    String data = Timestamp.now().toString();

    if (mensageText.isNotEmpty) {
      Mensage mensage =
          Mensage(idUser: sendUserId, text: mensageText, data: data);

      //salvar mensagem para remetente
      String recipientUserId = _recipientUser.idUser;
      _saveMensage(recipientUserId, sendUserId, mensage);

      //salvar mensagem para o destinatario
      _saveMensage(sendUserId, recipientUserId, mensage);
    }
  }

  _saveMensage(String recipientId, String sendId, Mensage mensage) {
    _firestore
        .collection("mensages")
        .doc(sendId)
        .collection(recipientId)
        .add(mensage.toMap());

    _mensageController.clear();
  }

  /*
    estrutura das mensagens
    mensagens
      + Denis
        + Marcos
          + mensagem (Denis)
      
      + Marcos
        + Denis
          + mensagem (Denis)
    
   */

  _recoverInitialData() {
    _sendUser = widget.sendUser;
    _recipientUser = widget.recipientUser;

    _mensageListenerAdd();
  }

  _mensageListenerAdd() {
    final stream = _firestore
        .collection("mensages")
        .doc(_sendUser.idUser)
        .collection(_recipientUser.idUser)
        .orderBy("data", descending: false)
        .snapshots();
    _streamMensages = stream.listen((data) {
      _streamController.add(data);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamMensages.cancel();
  }

  @override
  void initState() {
    super.initState();
    _recoverInitialData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("image/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          //mensage list
          StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Text("Carregando dados"),
                            CircularProgressIndicator()
                          ],
                        ),
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
                      List<DocumentSnapshot> mensagesList =
                          querySnapshot.docs.toList();
                      return Expanded(
                        child: ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot mensage = mensagesList[index];
                              Alignment alignment = Alignment.bottomLeft;
                              Color color = Colors.white;

                              if (_sendUser.idUser == mensage["idUser"]) {
                                alignment = Alignment.bottomRight;
                                color = PaleteColors.backgroundColorCarMensage;
                              }

                              return Align(
                                alignment: alignment,
                                child: Container(
                                  //define o maximo de largura que o container pode ter
                                  //ele recebe um size.
                                  constraints: BoxConstraints.loose(size * 0.8),
                                  margin: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.all(16),
                                  child: Text(mensage["text"]),
                                ),
                              );
                            }),
                      );
                    }
                }
              }),

          //box of the text
          Container(
            padding: const EdgeInsets.all(8.0),
            color: PaleteColors.backgroundColorBar,
            child: Row(
              children: [
                //box text circle
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_emoticon),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: TextField(
                          controller: _mensageController,
                          decoration: const InputDecoration(
                            hintText: "Digite uma mensagem",
                            border: InputBorder.none,
                          ),
                        )),
                        const Icon(Icons.attach_file),
                        const Icon(Icons.camera_alt),
                      ],
                    ),
                  ),
                ),

                //float button
                FloatingActionButton(
                    backgroundColor: PaleteColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    mini: true,
                    onPressed: _sendMensage),
              ],
            ),
          )
        ]));
  }
}
