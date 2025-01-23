class Mensage {
  String idUser;
  String text;
  String data;

  Mensage({required this.idUser, required this.text, required this.data});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"idUser": idUser, "text": text, "data": data};
    return map;
  }
}
