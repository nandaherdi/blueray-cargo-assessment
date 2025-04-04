import 'dart:convert';

// List<CustomerModel> customerModelFromJson(
//         String str) =>
//     List<CustomerModel>.from(json
//         .decode(str)
//         .map((x) => CustomerModel.fromJson(x)));

CustomerModel customerModelFromJson(String str) => CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    required this.customerId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    required this.birthPlace,
    required this.birthday,
  });

  int customerId;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String gender;
  String birthPlace;
  String birthday;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    customerId: json["customer_id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phoneNumber: json["phone_number"] ?? "-",
    gender: json["gender"] ?? "-",
    birthPlace: json["birth_place"] ?? "-",
    birthday: json["birthday"] ?? "-",
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "phone_number": phoneNumber,
    "gender": gender,
    "birth_place": birthPlace,
    "birthday": birthday,
  };
}
