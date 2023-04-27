import "dart:convert";

import "package:http/http.dart" as http;
import "package:multipay/src/models/ualabis/ualabis_access_token.dart";
import "package:multipay/src/models/ualabis/ualabis_client_credentials.dart";

class UalaBisManager {
  static final UalaBisManager _instance = UalaBisManager._();
  bool sandboxEnvironment = true;

  factory UalaBisManager() {
    return _instance;
  }

  UalaBisManager._();

  Future<UalaBisClientCredentialsModel> postRequestAccessToken(
      UalaBisClientCredentialsModel client) async {
    var response = await http.post(
      Uri.https(
        "auth.prod.ua.la",
        "/1/auth/token",
      ),
      body: client.toJson(),
    );

    client.accessToken =
        UalaBisAccessTokenModel.fromJson(json.decode(response.body));

    return client;
  }
}
