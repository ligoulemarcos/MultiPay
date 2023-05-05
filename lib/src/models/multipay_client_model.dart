import 'package:multipay/src/mercadopago/mercado_pago_manager.dart';
import 'package:multipay/src/models/macro/macro_client_credentials.dart';
import 'package:multipay/src/models/mercadopago/mercadopago_client_credentials.dart';
import 'package:multipay/src/models/ualabis/ualabis_client_credentials.dart';
import 'package:multipay/src/models/viumi/viumi_client_credentials_model.dart';

class MultiPayClientModel {
  MacroClientCredentialsModel? macroCredentials;
  MercadoPagoClientCredentials? mercadoPagoCredentials;
  UalaBisClientCredentialsModel? ualaBisCredentials;
  ViumiClientCredentialsModel? viumiCredentials;

  MultiPayClientModel({
    this.macroCredentials,
    this.mercadoPagoCredentials,
    this.ualaBisCredentials,
    this.viumiCredentials,
  });

  Future<void> setMercadoPagoCredentials({
    String? publicKey,
    String? preferencesId,
    bool? sandbox,
  }) async {
    var test = await MercadoPagoManager().getPurchasePreferenceId();
    mercadoPagoCredentials = MercadoPagoClientCredentials(
      publicKey: publicKey,
      preferenceId: sandbox != null && sandbox ? test!["id"] : preferencesId,
      url: sandbox != null && sandbox ? test!["sandbox_init_point"] : "",
    );
  }

  void setUalaBisCredentials({
    String? userName,
    String? clientId,
    String? clientSecret,
    String? grantType,
  }) {
    ualaBisCredentials = UalaBisClientCredentialsModel(
      userName: userName,
      clientId: clientId,
      clientSecret: clientSecret,
      grantType: grantType,
    );
  }
}
