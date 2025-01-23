import 'package:flutter/material.dart';
import 'package:wats_web/utils/palete_colors.dart';

class MensagesList extends StatefulWidget {
  const MensagesList({super.key});

  @override
  State<MensagesList> createState() => _MensagesListState();
}

class _MensagesListState extends State<MensagesList> {
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
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.insert_emoticon),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                            hintText: "Digite uma mensagem",
                            border: InputBorder.none,
                          ),
                        )),
                        Icon(Icons.attach_file),
                        Icon(Icons.camera_alt),
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
                    onPressed: () {}),
              ],
            ),
          )
        ]));
  }
}
