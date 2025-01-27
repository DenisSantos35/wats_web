class Conversation {
  String recipientId;
  String sendId;
  String lastMensage;
  String recipentName;
  String recipientEmail;
  String recipientImageUrl;

  Conversation({
    required this.recipientId,
    required this.sendId,
    required this.lastMensage,
    required this.recipentName,
    required this.recipientEmail,
    required this.recipientImageUrl,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "recipientId": recipientId,
      "sendId": sendId,
      "lastMensage": lastMensage,
      "recipentName": recipentName,
      "recipientEmail": recipientEmail,
      "recipientImageUrl": recipientImageUrl
    };

    return map;
  }
}
