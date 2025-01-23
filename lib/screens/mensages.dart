import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wats_web/component/mensages_list.dart';
import 'package:wats_web/models/user.dart';

class Mensages extends StatefulWidget {
  final Users recipientUser;
  const Mensages(this.recipientUser, {super.key});

  @override
  State<Mensages> createState() => _MensagesState();
}

class _MensagesState extends State<Mensages> {
  late Users _recipientUser;

  _recoverInitialData() {
    _recipientUser = widget.recipientUser;
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
        child: MensagesList(),
      ),
    );
  }
}
