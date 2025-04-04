import 'dart:convert';

List<AuthorizationModel> authorizationModelFromJson(String str) =>
    List<AuthorizationModel>.from(json.decode(str).map((x) => AuthorizationModel.fromJson(x)));

String authorizationModelToJson(AuthorizationModel data) => json.encode(data.toJson());

class AuthorizationModel {
  AuthorizationModel({required this.token, required this.tokenExpiryDate});

  String token;
  DateTime tokenExpiryDate;

  factory AuthorizationModel.fromJson(Map<String, dynamic> json) =>
      AuthorizationModel(token: json['token'], tokenExpiryDate: DateTime.parse(json['token_expiry_date']));

  Map<String, Object> toJson() => {'token': token, 'token_expiry_date': tokenExpiryDate.toString()};

  @override
  String toString() {
    return 'AuthorizationModel{token: $token, token_expiry_date: $tokenExpiryDate}';
  }
}
