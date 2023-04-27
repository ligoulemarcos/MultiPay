class ViumiAccessTokenModel {
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;

  ViumiAccessTokenModel({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
  });

  factory ViumiAccessTokenModel.fromJson(Map<String, dynamic> json) {
    return ViumiAccessTokenModel(
      tokenType: json["grant_type"],
      expiresIn: int.tryParse(json["client_id"]),
      accessToken: json["client_secret"],
      refreshToken: json["scope"] ?? "*",
    );
  }

  Map<String, dynamic> toJson() => {
        "grant_type": tokenType,
        "client_id": expiresIn,
        "client_secret": accessToken,
        "scope": refreshToken,
      };
}
