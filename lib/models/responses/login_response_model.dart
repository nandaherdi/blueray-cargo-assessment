import 'dart:convert';

import 'package:blueray_cargo_assessment/models/customer_model.dart';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({required this.login, this.token, this.tokenExpiryDate, this.customer, this.message});

  bool login;
  String? token;
  DateTime? tokenExpiryDate;
  CustomerModel? customer;
  String? message;

  factory LoginResponseModel.fromJson(Map<String, dynamic> data) => LoginResponseModel(
    login: data["login"],
    token: data["token"],
    tokenExpiryDate: DateTime.tryParse(data["token_expiry_date"].toString()),
    customer: data["customer"] == null ? null : customerModelFromJson(json.encode(data["customer"])),
    message: data["message"],
  );

  Map<String, dynamic> toJson() => {
    "login": login,
    "token": token,
    "customer": customerModelToJson(customer!),
    "message": message,
  };
}
