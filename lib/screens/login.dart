import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wats_web/utils/palete_colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerName =
      TextEditingController(text: "Dênis Santos");
  final TextEditingController _controllerEmail =
      TextEditingController(text: "denis@gmail.com");
  final TextEditingController _controllerPassword =
      TextEditingController(text: "1234567");
  bool _createUser = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;
  Uint8List? _selectImageFile;

  _selectImage() async {
    //captura imagem selecionada e armazena em resultado
    //select file
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    // recover file
    setState(() {
      _selectImageFile = result?.files.single.bytes;
      ByteBuffer buffer = _selectImageFile!.buffer;
      print("arquivo: ${buffer}");
      Uint8List teste = Uint8List.view(buffer);
      print("arquivo: ${teste}");
    });
  }

  // _uploadImage(String idUser) {
  //   //promove a imagem para ser reconhecido pelo dart
  //   Uint8List? selectFile = _selectImageFile;
  //   if (selectFile != null) {
  //     Reference imagePerfilRef = _storage.ref("imagens/perfil/$idUser.jpg");
  //     UploadTask uploadTask = imagePerfilRef.putData(selectFile);

  //     uploadTask.whenComplete(() async {
  //       String linkImage = await uploadTask.snapshot.ref.getDownloadURL();
  //       print("link da imagem: $linkImage");
  //     });
  //   }
  // }

  _validateFields() async {
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length > 6) {
        if (_createUser) {
          if (_selectImageFile != null) {
            //Cadastro
            if (name.isNotEmpty && name.length >= 3) {
              await _auth
                  .createUserWithEmailAndPassword(
                email: email,
                password: password,
              )
                  .then((auth) {
                //upload
                String? idUser = auth.user?.uid;
                //print("Usuário cadastrado: $idUsuario");
                // if (idUser != null) {
                //   _uploadImage(idUser);
                // }
              });
            } else {
              print("Nome inváido, digite ao menos 3 caracteres");
            }
          } else {
            print("Selecione uma imagem");
          }
        } else {
          //Login
          await _auth
              .signInWithEmailAndPassword(email: email, password: password)
              .then((auth) {
            String? email = auth.user?.email;
            print('Usuario cadastrado: $email');
          });
        }
      } else {
        print("Senha inválida");
      }
    } else {
      print("Email inválido");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
            color: PaleteColors.corFundo,
            height: screenHeight,
            width: screenWidth,
            child: Stack(children: [
              Positioned(
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.5,
                  color: PaleteColors.primaryColor,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        width: 500,
                        child: Column(
                          children: [
                            //perfil image with button
                            Visibility(
                              visible: _createUser,
                              child: ClipOval(
                                child: _selectImageFile != null
                                    ? Image.memory(
                                        _selectImageFile!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "image/perfil.png",
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Visibility(
                              visible: _createUser,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: _selectImage,
                                child: const Text("Selecionar foto"),
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            //Box text name
                            Visibility(
                              visible: _createUser,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: _controllerName,
                                decoration: const InputDecoration(
                                  hintText: "Nome",
                                  labelText: "Nome",
                                  suffixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                            ),

                            //box text of email
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _controllerEmail,
                              decoration: const InputDecoration(
                                hintText: "Email",
                                labelText: "Email",
                                suffixIcon: Icon(Icons.mail_outline),
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.text,
                              controller: _controllerPassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: "Senha",
                                labelText: "Senha",
                                suffixIcon: Icon(Icons.lock_outline),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _validateFields();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PaleteColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    _createUser ? "Cadastro" : "Login",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Text("Login"),
                                Switch(
                                  value: _createUser,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _createUser = value;
                                    });
                                  },
                                ),
                                const Text("Cadastro"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ])));
  }
}
