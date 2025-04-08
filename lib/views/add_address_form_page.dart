import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/dialog_foreground_process_model.dart';
import 'package:blueray_cargo_assessment/models/requests/add_address_model.dart';
import 'package:blueray_cargo_assessment/view_models/add_address_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/customer_address_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:blueray_cargo_assessment/views/maps_page.dart';
import 'package:blueray_cargo_assessment/widgets/district_search_widget.dart';
import 'package:blueray_cargo_assessment/widgets/get_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AddAddressFormPage extends StatefulWidget {
  final String title;
  const AddAddressFormPage({super.key, required this.title});

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
  TextEditingController _mapsLocationController = TextEditingController();

  @override
  void initState() {
    Future.microtask(()=> navigatorKey.currentContext!.read<AddAddressViewModel>().onStart());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
   _phoneNumberController.dispose();
   _phoneNumber2Controller.dispose();
   _districtController.dispose();
   _postalCodeController.dispose();
   _addressController.dispose();
   _addressLabelController.dispose();
   _emailController.dispose();
   _taxIdNumberController.dispose();
   _mapsLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var baseViewModel = context.read<BaseViewModel>();
    var addAddressViewModel = context.read<AddAddressViewModel>();
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(heroTag: 'save', onPressed: () async {
          await baseViewModel.dialogForegroundProcess(
            () async 
              => await addAddressViewModel.onSave(
                AddAddressModel(
                  name: _nameController.text,
                  phoneNumber: _phoneNumberController.text,
                  phoneNumber2: _phoneNumber2Controller.text,
                  provinceId: addAddressViewModel.selectedSubDistrict?.provinceId,
                  districtId: addAddressViewModel.selectedSubDistrict?.districtId,
                  subDistrictId: addAddressViewModel.selectedSubDistrict?.subDistrictId,
                  postalCode: _postalCodeController.text,
                  long: addAddressViewModel.mapsCoordinate?.longitude,
                  lat: addAddressViewModel.mapsCoordinate?.latitude,
                  address: _addressController.text,
                  addressMap: addAddressViewModel.mapsAddress,
                  email: _emailController.text,
                  npwp: _taxIdNumberController.text,
                  npwpFile: context.read<GetImageViewModel>().tempImage
                )
              ),
            DialogForegroundProcessModel(
              title: 'Berhasil',
              message: 'Menyimpan alamat berhasil',
              action: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                context.read<CustomerAddressViewModel>().onInit();
              },
              buttonText: 'Oke'
            )
          );
        }, child: Text('Simpan'),),
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
                    controller: _addressLabelController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label),
                      labelText: 'Label Alamat',
                    ),
                    validator: (value) {
                      String? error = baseViewModel.validateAddress(value);
                      if (error == null) {
                        addAddressViewModel.addressFormValidation.addressLabel = true;
                      } else {
                        addAddressViewModel.addressFormValidation.addressLabel = false;
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
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<AddAddressViewModel>(
                          builder: (context, addAddressProvider, _) {
                            _mapsLocationController.text = addAddressProvider.mapsAddress ?? '';
                            return TextFormField(
                              // initialValue: addAddressProvider.mapsAddress,
                              enabled: false,
                              controller: _mapsLocationController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_on_sharp),
                                labelText: 'Lokasi',
                              ),
                            );
                          }
                        ),
                      ),
                      TextButton(onPressed: () => context.pushTransition(type: PageTransitionType.rightToLeft, child: MapsPage()), child: Text('add')),
                    ],
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
                  GetImageWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
