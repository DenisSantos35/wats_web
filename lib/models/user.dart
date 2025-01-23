import 'dart:typed_data';

import 'package:flutter/material.dart';

class Users {
  String idUser;
  String name;
  String email;
  String urlImage;
  Uint8List? imageByte;

  Users(this.idUser, this.name, this.email,
      {this.urlImage = '', this.imageByte});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": idUser,
      "name": name,
      "email": email,
      "urlImage": urlImage
    };
    return map;
  }
}
