import 'dart:convert';

List<RegisterMandatoryModel> registerMandatoryModelFromJson(
        String str) =>
    List<RegisterMandatoryModel>.from(json
        .decode(str)
        .map((x) => RegisterMandatoryModel.fromJson(x)));

String registerMandatoryModelToJson(
        RegisterMandatoryModel data) =>
    json.encode(data.toJson());

class RegisterMandatoryModel {
  RegisterMandatoryModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.secondUserId,
    required this.password,
    required this.idCardNumber,
    required this.idCardImage,
    required this.idCardAddress,
    required this.idCardName
  });

  String userId;
  String firstName;
  String lastName;
  String secondUserId;
  String password;
  String idCardNumber;
  String idCardImage;
  String idCardAddress;
  String idCardName;

  factory RegisterMandatoryModel.fromJson(
          Map<String, dynamic> json) =>
      RegisterMandatoryModel(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        secondUserId: json["second_user_id"],
        password: json["password"],
        idCardNumber: json["id_card_number"],
        idCardImage: json["id_card_image"],
        idCardAddress: json["id_card_address"],
        idCardName: json["id_card_name"]
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "second_user_id": secondUserId,
        "password": password,
        "id_card_number": idCardNumber,
        "id_card_image": idCardImage,
        "id_card_address": idCardAddress,
        "id_card_name": idCardName
      };
}
