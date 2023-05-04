import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multipay/src/mercadopago/mercado_pago_manager.dart';
import 'package:multipay/src/mercadopago/payment_result.dart';
import 'package:multipay/src/models/ualabis/ualabis_client_credentials.dart';
import 'package:multipay/src/ualabis/ualabis.dart';
import 'package:multipay/src/viumi/viumi_checkout.dart';
import 'package:multipay/src/models/viumi/viumi_client_credentials_model.dart';

export 'package:multipay/src/mercadopago/payment_result.dart';

class MultiPay {
  static const MethodChannel _channel = MethodChannel("Multipay");

  ///Dummy method to test the PlatformChannel
  ///You can use this to add the platform used in checkout
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod("getPlatformVersion");

    return version;
  }

  static Future<PaymentResult> mercadoPagoCheckout(
    String publicKey,
    String preferenceId,
  ) async {
    return MercadoPagoManager().startCheckout(
      publicKey,
      preferenceId,
      _channel,
    );
  }

  static viumiCheckout(
    ViumiClientCredentialsModel client,
    Map<String, dynamic> purchaseDetail,
  ) async {
    var generateClientToken =
        await ViumiCheckoutManager().postViumiClient(client);
    return await ViumiCheckoutManager().postGeneratePaymentIntent(
      generateClientToken,
      purchaseDetail,
    );
  }

  static ualaBisCheckout({
    required UalaBisClientCredentialsModel client,
    required double totalPrice,
    required String description,
    required String callbackSuccessURL,
    required String callbackFailURL,
    String? notificationURL,
  }) async {
    var generateClientToken =
        await UalaBisManager().postRequestAccessToken(client);

    return await UalaBisManager().postUalaBisCheckout(
      client: generateClientToken,
      totalPrice: totalPrice.toString(),
      description: description,
      callbackSuccess: callbackSuccessURL,
      callbackFail: callbackFailURL,
      notificationURL: notificationURL,
    );
  }

  static getPaymentButtonsRack() {
    return InkWell(
      child: Container(
        color: Colors.purple,
        child: Text("TEST"),
      ),
    );
  }
}
