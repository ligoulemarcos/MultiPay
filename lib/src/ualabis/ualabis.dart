import "dart:convert";

import "package:http/http.dart" as http;

class UalaBisManager {
  static final UalaBisManager _instance = UalaBisManager._();
  bool sandboxEnvironment = true;

  factory UalaBisManager() {
    return _instance;
  }

  UalaBisManager._();

  Future<Map<String, dynamic>> postRequestAccessToken(
      Map<String, dynamic> client) async {
    var response = await http.post(
      Uri.https(
        "auth.prod.ua.la",
        "/1/auth/token",
      ),
      body: client,
    );

    return json.decode(response.body);
  }
}
