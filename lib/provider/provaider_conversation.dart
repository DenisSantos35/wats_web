import 'package:flutter/material.dart';
import 'package:wats_web/models/user.dart';

class ProvaiderConversation with ChangeNotifier {
  Users? _recipientUser;

  Users? get recipientUser => _recipientUser;

  set recipientUser(Users? user) {
    _recipientUser = user;
    notifyListeners();
  }
}
