import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wats_web/utils/palete_colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerName =
      TextEditingController(text: "Dênis Santos");
  TextEditingController _controllerEmail =
      TextEditingController(text: "denis@gmail.com");
  TextEditingController _controllerPassword =
      TextEditingController(text: "1234567");
  bool _createUser = false;

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
                                child: Image.asset(
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
                                onPressed: () {},
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
                                onPressed: () {},
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
