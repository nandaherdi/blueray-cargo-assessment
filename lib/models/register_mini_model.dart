import 'dart:convert';

List<RegisterMiniModel> registerMiniModelFromJson(
        String str) =>
    List<RegisterMiniModel>.from(json
        .decode(str)
        .map((x) => RegisterMiniModel.fromJson(x)));

String registerMiniModelToJson(
        RegisterMiniModel data) =>
    json.encode(data.toJson());

class RegisterMiniModel {
  RegisterMiniModel({
    required this.userId
  });

  String userId;

  factory RegisterMiniModel.fromJson(
          Map<String, dynamic> json) =>
      RegisterMiniModel(
        userId: json["user_id"]
      );

  Map<String, Object> toJson() => {
        "user_id": userId
      };
}
