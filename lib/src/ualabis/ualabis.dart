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

  Future<Map<String, dynamic>?> postUalaBisCheckout({
    required UalaBisClientCredentialsModel client,
    required String totalPrice,
    required String description,
    required String callbackSuccess,
    required String callbackFail,
    String? notificationURL,
  }) async {
    var response = await http.post(
      Uri.https(
        "checkout.prod.ua.la",
        "/1/checkout",
      ),
      headers: {
        "Authorization": "Bearer ${client.accessToken!.accessToken!}",
      },
      body: {
        "amount": totalPrice,
        "description": description,
        "userName": client.userName,
        "callback_fail": callbackFail,
        "callback_success": callbackSuccess,
        "notification_url": notificationURL,
      },
    );

    return json.decode(response.body);
  }
}
