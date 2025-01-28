import 'package:flutter/material.dart';
import 'package:wats_web/utils/palete_colors.dart';
import 'package:wats_web/utils/responsive.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double heigth = MediaQuery.of(context).size.height;
    final bool isWeb = Responsive.isWeb(context);
    return Scaffold(
      body: Container(
        color: PaleteColors.corFundo,
        child: Stack(
          children: [
            //posiciona o widget em locais escolhidos na tela.
            Positioned(
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
                      child: SideConversationArea(),
                    ),
                    Expanded(
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
  const SideConversationArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.orange,
    );
  }
}

class SideMensageArea extends StatelessWidget {
  const SideMensageArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.purple,
    );
  }
}
