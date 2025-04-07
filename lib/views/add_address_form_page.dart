import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/view_models/add_address_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:blueray_cargo_assessment/widgets/district_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddressFormPage extends StatefulWidget {
  const AddAddressFormPage({super.key});

  @override
  State<AddAddressFormPage> createState() => _AddAddressFormPageState();
}

class _AddAddressFormPageState extends State<AddAddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _phoneNumber2Controller = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _addressLabelController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _taxIdNumberController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var baseViewModel = context.read<BaseViewModel>();
    var addAddressViewModel = context.read<AddAddressViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Alamat'), automaticallyImplyLeading: true),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                    labelText: 'Label Alamat',
                  ),
                  validator: (value) {
                    String? error = baseViewModel.validateAddress(value);
                    if (error == null) {
                      addAddressViewModel.addressFormValidation.address = true;
                    } else {
                      addAddressViewModel.addressFormValidation.address = false;
                    }
                    addAddressViewModel.validateAddressForm();
                    return error;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Nama Penerima',
                  ),
                  validator: (value) {
                    String? error = baseViewModel.validatePlainText(value, 'nama penerima', 50);
                    if (error == null) {
                      addAddressViewModel.addressFormValidation.name = true;
                    } else {
                      addAddressViewModel.addressFormValidation.name = false;
                    }
                    addAddressViewModel.validateAddressForm();
                    return error;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Nomor Telepon',
                  ),
                  validator: (value) {
                    String? error = baseViewModel.validatePhoneNumber(value);
                    if (error == null) {
                      addAddressViewModel.addressFormValidation.phoneNumber = true;
                    } else {
                      addAddressViewModel.addressFormValidation.phoneNumber = false;
                    }
                    addAddressViewModel.validateAddressForm();
                    return error;
                  },
                ),
                TextFormField(
                  controller: _phoneNumber2Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Nomor Telepon 2',
                  ),
                  validator: (value) {
                    String? error = baseViewModel.validatePhoneNumber(value);
                    if (error == null) {
                      addAddressViewModel.addressFormValidation.phoneNumber2 = true;
                    } else {
                      addAddressViewModel.addressFormValidation.phoneNumber2 = false;
                    }
                    addAddressViewModel.validateAddressForm();
                    return error;
                  },
                ),
                DistrictSearchWidget(),
                Consumer<AddAddressViewModel>(
                  builder: (_, addAddressProvider, _) {
                    return TextFormField(
                      controller: _postalCodeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.markunread_mailbox),
                        labelText: 'Kode Pos',
                        suffix:
                            addAddressProvider.isValidatingPostCode
                                ? SizedBox(width: 15, height: 15, child: Center(child: CircularProgressIndicator()))
                                : SizedBox(),
                      ),
                      onChanged:
                          (value) => context.read<BaseViewModel>().shimmerForegroundProcess(
                            () => addAddressProvider.validatePostCode(value),
                          ),
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: (_) => addAddressProvider.validatePostalCode(),
                      validator: (value) {
                        String? error = addAddressProvider.validatePostalCode();
                        if (error == null) {
                          addAddressViewModel.addressFormValidation.postalCode = true;
                        } else {
                          addAddressViewModel.addressFormValidation.postalCode = false;
                        }
                        addAddressViewModel.validateAddressForm();
                        return error;
                      },
                    );
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.map),
                    labelText: 'Alamat',
                  ),
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) {
                    String? error = baseViewModel.validateAddress(value);
                    if (error == null) {
                      addAddressViewModel.addressFormValidation.address = true;
                    } else {
                      addAddressViewModel.addressFormValidation.address = false;
                    }
                    addAddressViewModel.validateAddressForm();
                    return error;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.alternate_email),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    String? error = baseViewModel.validateEmail(value);
                    if (error == null) {
                      addAddressViewModel.addressFormValidation.email = true;
                    } else {
                      addAddressViewModel.addressFormValidation.email = false;
                    }
                    addAddressViewModel.validateAddressForm();
                    return error;
                  },
                ),
                TextFormField(
                  controller: _taxIdNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.credit_card),
                    labelText: 'NPWP',
                  ),
                  validator: (value) {
                    String? error = baseViewModel.validateTaxIDNumber(value);
                    if (error == null) {
                      addAddressViewModel.addressFormValidation.npwp = true;
                    } else {
                      addAddressViewModel.addressFormValidation.npwp = false;
                    }
                    addAddressViewModel.validateAddressForm();
                    return error;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
