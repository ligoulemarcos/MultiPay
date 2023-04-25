import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;

class ViumiCheckout {
  postViumiClient(Map<String, dynamic> data) async {
    var response = await http.post(Uri.https("auth.geopagos.com", "/oauth/token"), body: json.encode(data));
  }
}