import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wats_web/component/conversationList.dart';
import 'package:wats_web/models/user.dart';
import 'package:wats_web/utils/convert_data.dart';
import 'package:wats_web/utils/palete_colors.dart';
import 'package:wats_web/utils/responsive.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Users? _loggedUser; // Alterado para permitir valores nulos inicialmente
  Uint8List? _image;

  Future<void> _recoverImageUser() async {
    String? doc = _auth.currentUser?.uid.toString();
    if (doc != null) {
      final DocumentSnapshot<Map<String, dynamic>> data =
          await _firestore.collection("users").doc(doc).get();
      final String? urlImage = data.data()?["urlImage"];

      if (urlImage != null && _loggedUser != null) {
        _loggedUser!.urlImage = urlImage;
        Uint8List img = ConvertData.convertBase64(urlImage);
        setState(() {
          _image = img;
          _loggedUser!.imageByte = img;
        });
      }
    }
  }

  Future<void> _recoverLoggedUserData() async {
    User? loggedUser = _auth.currentUser;

    if (loggedUser != null) {
      String idUser = loggedUser.uid;
      String? name = loggedUser.displayName ?? "";
      String? email = loggedUser.email ?? "";

      setState(() {
        _loggedUser = Users(idUser, name, email, urlImage: "");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recoverLoggedUserData().then((_) => _recoverImageUser());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double heigth = MediaQuery.of(context).size.height;
    final bool isWeb = Responsive.isWeb(context);

    // Verificação para evitar o uso de valores nulos
    if (_loggedUser == null || _image == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: PaleteColors.corFundo,
        child: Stack(
          children: [
            //posiciona o widget em locais escolhidos na tela.
            // todo widget dentro da stack precisa ter uma posição
            //para que ela cresça de acordo com o conteudo.
            Positioned(
              top: 0,
              child: Container(
                color: PaleteColors.primaryColor,
                width: width,
                height: heigth * 0.2,
              ),
            ),
            Positioned(
                top: isWeb ? heigth * 0.05 : 0,
                left: isWeb ? width * 0.05 : 0,
                right: isWeb ? width * 0.05 : 0,
                bottom: isWeb ? heigth * 0.05 : 0,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SideConversationArea(
                        loggedUser: _loggedUser!,
                      ),
                    ),
                    const Expanded(
                      flex: 10,
                      child: SideMensageArea(),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class SideConversationArea extends StatelessWidget {
  final Users loggedUser;
  const SideConversationArea({super.key, required this.loggedUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PaleteColors.backgroundColorBarLigth,
        border: Border(
          right: BorderSide(
            color: PaleteColors.corFundo,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          //top bar
          Container(
            color: PaleteColors.backgroundColorBar,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: Image.memory(
                      loggedUser.imageByte!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //empurra todos os icones para o final
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.message),
                ),
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ),
          //Barra de pesquisa
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "Pesquisar uma conversa",
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Lista de conversas
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Conversationlist(),
            ),
          )
        ],
      ),
    );
  }
}

class SideMensageArea extends StatelessWidget {
  const SideMensageArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double heigth = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: heigth,
      color: PaleteColors.backgroundColorBarLigth,
    );
  }
}
