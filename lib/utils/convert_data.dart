import 'dart:convert';
import 'dart:typed_data';

class ConvertData {
  static Uint8List convertBase64(String data) {
    final dataConvert = base64Decode(data);
    return dataConvert;
  }
}
