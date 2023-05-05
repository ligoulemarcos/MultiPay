import 'dart:async';
import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:flutter/services.dart';
import 'package:multipay/src/mercadopago/payment_result.dart';

class MercadoPagoManager {
  static final MercadoPagoManager _instance = MercadoPagoManager._();

  factory MercadoPagoManager() {
    return _instance;
  }

  MercadoPagoManager._();

  ///Starts the checkout.
  ///
  ///Returns a PaymentResult with the information, or the error code.
  ///
  ///publicKey should be the key provided by MP in the App Credentials page.
  ///DO NOT use the Access Token here.
  ///
  ///preferenceId should be generated in backend with all the settings.
  ///Checkout can be personalized in several aspects.
  ///See <https://www.mercadopago.com.ar/developers/es/guides/payments/mobile-checkout/personalization/>
  /// for more details.
  Future<PaymentResult> startCheckout(
      String publicKey, String preferenceId, MethodChannel channel) async {
    Map<String, dynamic>? result =
        await (channel.invokeMapMethod<String, dynamic>(
      'startCheckout',
      {
        "publicKey": publicKey,
        "preferenceId": preferenceId,
      },
    ));

    return PaymentResult.fromJson(result!);
  }

  //DUMMY: esto lo hace backend
  Future<Map<String, dynamic>?> getPurchasePreferenceId() async {
    var response = await http.post(
      Uri.https(
        "api.mercadopago.com",
        "checkout/preferences",
      ),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization":
            "Bearer TEST-4940267580865040-050416-ee66edefec3398284207ab68d01f399c-697699240",
      },
      body: jsonEncode({
        "items": [
          {
            "title": "Choripan en polvo",
            "description": "Un choripan, en polvo",
            "picture_url":
                "https://www.laylita.com/recetas/wp-content/uploads/Receta-del-choripan.jpg",
            "category_id": "food",
            "quantity": 1,
            "currency_id": "ARS",
            "unit_price": 50
          }
        ],
        "payer": {"phone": {}, "identification": {}, "address": {}},
        "payment_methods": {
          "excluded_payment_methods": [{}],
          "excluded_payment_types": [{}]
        },
        "shipments": {
          "free_methods": [{}],
          "receiver_address": {}
        },
        "back_urls": {},
        "differential_pricing": {},
        "tracks": [],
        "metadata": {}
      }),
    );

    return jsonDecode(response.body);
  }
}
