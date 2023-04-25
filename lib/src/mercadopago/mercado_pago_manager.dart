import 'dart:async';

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
  ///Can be personalized in several aspects.
  ///See <https://www.mercadopago.com.ar/developers/es/guides/payments/mobile-checkout/personalization/>
  /// for more details.
  Future<PaymentResult> startCheckout(String publicKey, String preferenceId, MethodChannel channel) async {
    Map<String, dynamic>? result = await (channel.invokeMapMethod<String, dynamic>("startCheckout", {"publicKey": publicKey, "preferenceId": preferenceId,},));

    return PaymentResult.fromJson(result!);
  }
}