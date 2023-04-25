import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multipay/src/mercado_pago_manager.dart';

export 'package:multipay/src/mercado_pago_manager.dart';
export 'package:multipay/src/payment_result.dart';

class MultiPay{
  static const MethodChannel _channel = MethodChannel("Multipay");
  static final MercadoPagoManager _mercadoPago = MercadoPagoManager();

  static MercadoPagoManager get mercadoPago => _mercadoPago;

  ///Dummy method to test the PlatformChannel
  ///You can use this to add the platform used in checkout
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod("getPlatformVersion");

    return version;
  }
}