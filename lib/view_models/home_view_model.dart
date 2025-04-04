import 'package:blueray_cargo_assessment/models/customer_model.dart';
import 'package:blueray_cargo_assessment/services/customer_table_provider.dart';
import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  CustomerModel? _customer;

  CustomerModel? get customer => _customer;

  set customer(CustomerModel? newValue) {
    _customer = newValue;
    notifyListeners();
  }

  Future<void> onInit() async {
    customer = null;
    CustomerTableProvider customerTableProvider = CustomerTableProvider();
    customer = await customerTableProvider.getData().then((value) => value.first);
  }
}
