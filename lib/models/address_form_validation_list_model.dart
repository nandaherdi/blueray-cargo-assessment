class AddressFormValidationListModel {
  bool name = false;
  bool phoneNumber = false;
  bool phoneNumber2 = false;
  bool provinceId = false;
  bool districtId = false;
  bool subDistrictId = false;
  bool postalCode = false;
  bool long = false;
  bool lat = false;
  bool address = false;
  bool addressMap = false;
  bool addressLabel = false;
  bool email = false;
  bool npwp = false;
  bool npwpFile = false;

  AddressFormValidationListModel({
    required this.name,
    required this.phoneNumber,
    required this.phoneNumber2,
    required this.provinceId,
    required this.districtId,
    required this.subDistrictId,
    required this.postalCode,
    required this.long,
    required this.lat,
    required this.address,
    required this.addressMap,
    required this.addressLabel,
    required this.email,
    required this.npwp,
    required this.npwpFile,
  });
}
