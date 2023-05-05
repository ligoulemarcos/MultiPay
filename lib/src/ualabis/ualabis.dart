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
        sandboxEnvironment ? "auth.stage.ua.la" : "auth.prod.ua.la",
        "/1/auth/token",
      ),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode(client.toJson()),
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
        sandboxEnvironment ? "checkout.stage.ua.la" : "checkout.prod.ua.la",
        "/1/checkout",
      ),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer ${client.accessToken!.accessToken!}",
      },
      body: jsonEncode({
        "amount": totalPrice,
        "description": description,
        "userName": client.userName,
        "callback_fail": callbackFail,
        "callback_success": callbackSuccess,
        "notification_url": notificationURL ?? "",
      }),
    );

    var postAnswer = json.decode(response.body);
    List<String> urlStrings =
        ((postAnswer["links"])["checkoutLink"].toString()).split(".com");
    urlStrings[0] += ".com";
    urlStrings[0].substring(8);

    return postAnswer;
  }
}
