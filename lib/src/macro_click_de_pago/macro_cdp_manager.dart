import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:multipay/src/macro_click_de_pago/macro_access_token.dart';

import 'macro_client_credentials.dart';

class MacroCDPManager {
  Future<bool> checkAvailability({
    sandboxEnvironment = true,
  }) async {
    var response = await http.get(
      Uri.https(
        _getBaseURL(
          sandboxEnvironment,
        ),
        "health",
      ),
    );

    return json.decode(response.body)["status"] ?? false;
  }

  Future<MacroClientCredentialsModel?> getAccessToken({
    sandboxEnvironment = true,
    required MacroClientCredentialsModel client,
  }) async {
    if (!(await checkAvailability(
      sandboxEnvironment: sandboxEnvironment,
    ))) {
      return null;
    }

    var response = await http.post(
      Uri.https(
        _getBaseURL(sandboxEnvironment),
        "sesion",
      ),
      body: client.toJson(),
    );

    Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (!jsonResponse["status"]) return null;

    client.token = MacroAccessTokenModel.fromJson(json.decode(response.body));

    return client;
  }

  Future<Map<String, dynamic>?> getPaymentToken({
    sandboxEnvironment = true,
    String? branchOfficeClient,
    List<String>? products,
    double? totalPrice,
    String? commerceTransactionId,
    String? ip, //??????????????????????????????????????
    required MacroClientCredentialsModel client,
  }) async {
    var response = await http
        .post(Uri.https(_getBaseURL(sandboxEnvironment), "tokens"), headers: {
      "Authorization": "Bearer ${client.token!.accessToken!}",
      "Content-Type": "application/json",
    }, body: {
      "Comercio": client.guid,
      "SucursalComercio": branchOfficeClient,
      "Productos": products != null && products.isNotEmpty
          ? List<String>.from(products.map((x) => x))
          : null,
      "TransacicionComercioId": commerceTransactionId,
      "Ip": ip,
    });

    return json.decode(response.body);
  }

  _getBaseURL(bool isSandbox) => isSandbox
      ? "https://sandboxpp.asjservicios.com.ar:8082/v1/"
      : "https://botonpp.asjservicios.com.ar:8082/v1/";
}
