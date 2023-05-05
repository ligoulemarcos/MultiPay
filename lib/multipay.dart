import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multipay/src/mercadopago/payment_result.dart';
import 'package:multipay/src/models/multipay_client_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'src/mercadopago/mercado_pago_manager.dart';
import 'src/models/ualabis/ualabis_client_credentials.dart';
import 'src/models/viumi/viumi_client_credentials_model.dart';
import 'src/ualabis/ualabis.dart';
import 'src/viumi/viumi_checkout.dart';

export 'package:multipay/src/mercadopago/payment_result.dart';
export 'package:multipay/src/models/multipay_client_model.dart';

class MultiPay {
  static const MethodChannel _channel = MethodChannel("multipay");

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

    var checkout = await UalaBisManager().postUalaBisCheckout(
      client: generateClientToken,
      totalPrice: totalPrice.toString(),
      description: description,
      callbackSuccess: callbackSuccessURL,
      callbackFail: callbackFailURL,
      notificationURL: notificationURL,
    );

    String ospdkjfg = (checkout!["links"])["checkoutLink"];

    List<String> uriStrings = ospdkjfg.split(".com");
    uriStrings[0] += ".com";
    uriStrings[0] = uriStrings[0].substring(8);

    Uri checkoutURL = Uri.https(uriStrings[0], uriStrings[1]);

    return checkoutURL;
  }

  getPaymentButtonsRack(
    MultiPayClientModel client, {
    double? totalPrice,
    String? description,
  }) {
    return Column(
      children: [
        client.mercadoPagoCredentials != null
            ? Material(
                child: Center(
                  child: Ink(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 158, 227),
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        await MercadoPagoManager().startCheckout(
                          client.mercadoPagoCredentials!.publicKey!,
                          client.mercadoPagoCredentials!.preferenceId!,
                          _channel,
                        );
                      },
                      highlightColor: const Color.fromARGB(127, 0, 138, 214),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.network(
                            "https://logotipoz.com/wp-content/uploads/2021/10/version-horizontal-large-logo-mercado-pago.webp",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(
          height: 15,
        ),
        client.ualaBisCredentials != null
            ? Material(
                child: Center(
                  child: Ink(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(255, 2, 42, 155),
                        width: 1.5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        var test = await _test(
                          client,
                          totalPrice: totalPrice,
                          description: description,
                        );
                        await launchUrl(test);
                      },
                      highlightColor: const Color.fromARGB(127, 42, 75, 170),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.network(
                            "https://www.uala.com.ar/_next/static/media/logotipo-uala.f9c7a2c4.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(
          height: 15,
        ),
        client.viumiCredentials != null
            ? Material(
                child: Center(
                  child: Ink(
                    width: 200,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 69, 39, 160),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {},
                      highlightColor: const Color.fromARGB(127, 106, 82, 179),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          50,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          "packages/multipay/lib/assets/images/viumiTextLogo.png",
                          scale: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  _test(
    MultiPayClientModel client, {
    double? totalPrice,
    String? description,
  }) async {
    return await ualaBisCheckout(
      client: client.ualaBisCredentials!,
      totalPrice: totalPrice ?? 0,
      description: description ?? "",
      callbackSuccessURL: Uri.https("google.com").toString(),
      callbackFailURL: Uri.https("bing.com").toString(),
    );
  }
}
