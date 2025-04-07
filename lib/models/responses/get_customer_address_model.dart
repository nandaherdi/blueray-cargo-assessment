import 'dart:convert';

List<GetCustomerAddressModel> getCustomerAddressModelFromJson(String str) =>
    List<GetCustomerAddressModel>.from(json.decode(str).map((x) => GetCustomerAddressModel.fromJson(x)));

String getCustomerAddressModelToJson(GetCustomerAddressModel data) => json.encode(data.toJson());

class GetCustomerAddressModel {
  GetCustomerAddressModel({
    required this.provinceName,
    required this.districtName,
    required this.subDistrictName,
    required this.cityCode,
    required this.npwpFile,
    required this.name,
    required this.address,
    required this.postalCode,
    required this.email,
    required this.phoneNumber,
    this.phoneNumber2,
    this.npwp,
    this.long,
    this.lat,
    required this.addressMap,
  });

  String provinceName;
  String districtName;
  String subDistrictName;
  String cityCode;
  String npwpFile;
  String name;
  String address;
  String postalCode;
  String email;
  String phoneNumber;
  String? phoneNumber2;
  String? npwp;
  double? long;
  double? lat;
  String addressMap;

  factory GetCustomerAddressModel.fromJson(Map<String, dynamic> json) => GetCustomerAddressModel(
    provinceName: json['province_name'],
    districtName: json['district_name'],
    subDistrictName: json['sub_district_name'],
    cityCode: json['city_code'],
    npwpFile: json['npwp_file'],
    name: json['name'],
    address: json['address'],
    postalCode: json['postal_code'],
    email: json['email'],
    phoneNumber: json['phone_number'],
    phoneNumber2: json['phone_number_2'],
    npwp: json['npwp'],
    long: json['long'],
    lat: json['lat'],
    addressMap: json['address_map'],
  );

  Map<String, dynamic> toJson() => {
    'province_name': provinceName,
    'district_name': districtName,
    'sub_district_name': subDistrictName,
    'city_code': cityCode,
    'npwp_file': npwpFile,
    'name': name,
    'address': address,
    'postal_code': postalCode,
    'email': email,
    'phone_number': phoneNumber,
    'phone_number_2': phoneNumber2,
    'npwp': npwp,
    'long': long,
    'lat': lat,
    'address_map': addressMap,
  };
}
