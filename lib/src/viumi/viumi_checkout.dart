import "dart:convert";
import "package:http/http.dart" as http;
import 'package:multipay/src/viumi/viumi_access_token_model.dart';
import 'package:multipay/src/viumi/viumi_client_credentials_model.dart';

class ViumiCheckout {
  postViumiClient(ViumiClientCredentialsModel client) async {
    var response = await http.post(
      Uri.https(
        "auth.geopagos.com",
        "/oauth/token",
      ),
      body: client.toJson(),
    );

    if (response != null && response.body != null) {
      return ViumiAccessTokenModel.fromJson(
        json.decode(
          response.body,
        ),
      );
    }
  }
}
