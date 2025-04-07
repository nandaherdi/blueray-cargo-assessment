import 'package:blueray_cargo_assessment/models/responses/get_customer_address_model.dart';
import 'package:blueray_cargo_assessment/services/customer_address_service.dart';
import 'package:flutter/material.dart';

class CustomerAddressViewModel with ChangeNotifier {
  List<GetCustomerAddressModel>? _customerAddresses;

  List<GetCustomerAddressModel>? get customerAddresses => _customerAddresses;

  set customerAddresses(List<GetCustomerAddressModel>? newValue) {
    _customerAddresses = newValue;
    notifyListeners();
  }

  onInit() async {
    customerAddresses = null;
    List<GetCustomerAddressModel> customerAddressData = await CustomerAddressService.getCustomerAddress();
    customerAddresses = customerAddressData;
  }

  @override
  void dispose() {
    customerAddresses = null;
    super.dispose();
  }
}
