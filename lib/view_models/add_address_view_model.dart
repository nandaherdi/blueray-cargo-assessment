import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/address_form_validation_list_model.dart';
import 'package:blueray_cargo_assessment/models/requests/add_address_model.dart';
import 'package:blueray_cargo_assessment/models/responses/sub_district_search_model.dart';
import 'package:blueray_cargo_assessment/services/base_service.dart';
import 'package:blueray_cargo_assessment/services/customer_address_service.dart';
import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddAddressViewModel with ChangeNotifier {
  String? _mapsAddress;
  LatLng? _mapsCoordinate;
  List<SubDistrictSearchModel>? _searchResult = [];
  SubDistrictSearchModel? _selectedSubDistrict;
  bool _isValidatingPostCode = false;
  String? _postCodeErrorMessage;
  AddressFormValidationListModel _addressFormValidation = AddressFormValidationListModel(
    name: false,
    phoneNumber: false,
    phoneNumber2: false,
    provinceId: false,
    districtId: false,
    subDistrictId: false,
    postalCode: false,
    long: false,
    lat: false,
    address: false,
    addressMap: false,
    addressLabel: false,
    email: false,
    npwp: false,
    npwpFile: false,
  );
  bool _isAddressFormValid = false;

  String? get mapsAddress => _mapsAddress;
  LatLng? get mapsCoordinate => _mapsCoordinate;
  List<SubDistrictSearchModel>? get searchResult => _searchResult;
  SubDistrictSearchModel? get selectedSubDistrict => _selectedSubDistrict;
  bool get isValidatingPostCode => _isValidatingPostCode;
  String? get postCodeErrorMessage => _postCodeErrorMessage;
  AddressFormValidationListModel get addressFormValidation => _addressFormValidation;
  bool get isAddressFormValid => _isAddressFormValid;

  set searchResult(List<SubDistrictSearchModel>? newValue) {
    _searchResult = newValue;
    notifyListeners();
  }

  set selectedSubDistrict(SubDistrictSearchModel? newValue) {
    _selectedSubDistrict = newValue;
    notifyListeners();
  }

  set isValidatingPostCode(bool newValue) {
    _isValidatingPostCode = newValue;
    notifyListeners();
  }

  set postCodeErrorMessage(String? newValue) {
    _postCodeErrorMessage = newValue;
    notifyListeners();
  }

  set addressFormValidation(AddressFormValidationListModel newValue) {
    _addressFormValidation = newValue;
    notifyListeners();
  }

  set isAddressFormValid(bool newValue) {
    _isAddressFormValid = newValue;
    notifyListeners();
  }
  set mapsAddress(String? newValue) {
    _mapsAddress = newValue;
    notifyListeners();
  }
  set mapsCoordinate(LatLng? newValue) {
    _mapsCoordinate = newValue;
    notifyListeners();
  }

  @override
  void dispose() {
    mapsAddress = null;
    mapsCoordinate = null;
    searchResult = [];
    selectedSubDistrict = null;
    isValidatingPostCode = false;
    postCodeErrorMessage = null;
    addressFormValidation = AddressFormValidationListModel(
      name: false,
      phoneNumber: false,
      phoneNumber2: false,
      provinceId: false,
      districtId: false,
      subDistrictId: false,
      postalCode: false,
      long: false,
      lat: false,
      address: false,
      addressMap: false,
      addressLabel: false,
      email: false,
      npwp: false,
      npwpFile: false,
    );
    isAddressFormValid = false;
    super.dispose();
  }

  doSearch(String keyword) async {
    searchResult = null;
    List<SubDistrictSearchModel> result = await CustomerAddressService.subDistrictSearch(keyword);
    searchResult = result;
  }

  onSelectedSubDistrict(int index) {
    selectedSubDistrict = searchResult![index];
    Navigator.of(navigatorKey.currentContext!).pop();
  }
  

  Future<void> validatePostCode(String? keyword) async {
    if (keyword == null || keyword == '') {
      postCodeErrorMessage = 'mohon diisi';
    } else {
      isValidatingPostCode = true;
      var result = await CustomerAddressService.validatePostCode(keyword);
      isValidatingPostCode = false;
      if (!result.action) {
        postCodeErrorMessage = result.message;
      } else {
        postCodeErrorMessage = null;
      }
    }
  }

  String? validatePostalCode() {
    return postCodeErrorMessage;
  }

  String? validateDistrict() {
    if (selectedSubDistrict == null) {
      addressFormValidation.districtId = false;
      addressFormValidation.subDistrictId = false;
      addressFormValidation.provinceId = false;
      return "tolong isi kecamatan/kota";
    } else {
      addressFormValidation.districtId = true;
      addressFormValidation.subDistrictId = true;
      addressFormValidation.provinceId = true;
      return null;
    }
  }

  void validateAddressForm() {
    addressFormValidation.npwpFile = navigatorKey.currentContext!.read<GetImageViewModel>().tempImage != null;
    if (addressFormValidation.name == true &&
        addressFormValidation.phoneNumber == true &&
        addressFormValidation.phoneNumber2 == true &&
        addressFormValidation.provinceId == true &&
        addressFormValidation.districtId == true &&
        addressFormValidation.subDistrictId == true &&
        addressFormValidation.postalCode == true &&
        addressFormValidation.long == true &&
        addressFormValidation.lat == true &&
        addressFormValidation.address == true &&
        addressFormValidation.addressMap == true &&
        addressFormValidation.addressLabel == true &&
        addressFormValidation.email == true &&
        addressFormValidation.npwp == true &&
        addressFormValidation.npwpFile == true) {
      isAddressFormValid = true;
    } else {
      isAddressFormValid = false;
    }
  }

  onStart(){
    mapsAddress = null;
    mapsCoordinate = null;
    searchResult = [];
    selectedSubDistrict = null;
    isValidatingPostCode = false;
    postCodeErrorMessage = null;
    addressFormValidation = AddressFormValidationListModel(
      name: false,
      phoneNumber: false,
      phoneNumber2: false,
      provinceId: false,
      districtId: false,
      subDistrictId: false,
      postalCode: false,
      long: false,
      lat: false,
      address: false,
      addressMap: false,
      addressLabel: false,
      email: false,
      npwp: false,
      npwpFile: false,
    );
    isAddressFormValid = false; 
  }

  Future<void> onSave(AddAddressModel address) async {
    validateAddressForm();
    if (!isAddressFormValid) {
      throw 'tolong isi semua data dengan lengkap';
    } else {
      var saveImageResult = await BaseService.uploadImage(File(address.npwpFile!));
      if (saveImageResult.action) {
        address.npwpFile = saveImageResult.value.toString();
        await CustomerAddressService.saveAddress(requestData: address);
      } else {
        throw saveImageResult.message;
      }
      
    }
  }

  
}
