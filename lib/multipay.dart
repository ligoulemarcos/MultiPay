import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multipay/src/mercadopago/mercado_pago_manager.dart';
import 'package:multipay/src/mercadopago/payment_result.dart';
import 'package:multipay/src/viumi/viumi_checkout.dart';
import 'package:multipay/src/models/viumi/viumi_client_credentials_model.dart';

export 'package:multipay/src/mercadopago/payment_result.dart';

class MultiPay {
  static const MethodChannel _channel = MethodChannel("Multipay");
  static final MercadoPagoManager _mercadoPago = MercadoPagoManager();
  static final ViumiCheckoutManager _viumi = ViumiCheckoutManager();

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
    return _mercadoPago.startCheckout(
      publicKey,
      preferenceId,
      _channel,
    );
  }

  static viumiCheckout(
    ViumiClientCredentialsModel client,
    Map<String, dynamic> purchaseDetail,
  ) async {
    var generateClientToken = await _viumi.postViumiClient(client);
    return await _viumi.postGeneratePaymentIntent(
      generateClientToken,
      purchaseDetail,
    );
  }
}
