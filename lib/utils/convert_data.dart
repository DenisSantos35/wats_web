import 'dart:convert';
import 'dart:typed_data';

class ConvertData {
  static Uint8List convertBase64(String data) {
    final dataConvert = base64Decode(data);
    return dataConvert;
  }
}

class DeconvertData {
  static String decodebase64Encode({required Uint8List? data}) {
    if (data != null) {
      ByteBuffer buffer = data.buffer;
      String base64String = base64Encode(Uint8List.view(buffer));
      return base64String;
    }
    return "";
  }
}
