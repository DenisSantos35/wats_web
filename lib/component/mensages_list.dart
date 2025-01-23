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
  TextEditingController _mensageController = TextEditingController();
  late Users _recipientUser;
  late Users _sendUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  _recoverInitialData() {
    _sendUser = widget.sendUser;
    _recipientUser = widget.recipientUser;
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
          Expanded(
              child: Container(
                  width: size.width,
                  color: Colors.orange,
                  child: const Text("Lista mensagem"))),

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
