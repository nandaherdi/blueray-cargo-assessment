import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/authorization_model.dart';
import 'package:blueray_cargo_assessment/models/customer_model.dart';
import 'package:blueray_cargo_assessment/models/register_mandatory_model.dart';
import 'package:blueray_cargo_assessment/models/register_mini_model.dart';
import 'package:blueray_cargo_assessment/models/register_resend_code_model.dart';
import 'package:blueray_cargo_assessment/models/register_verify_code_model.dart';
import 'package:blueray_cargo_assessment/models/requests/login_request_model.dart';
import 'package:blueray_cargo_assessment/models/response_model.dart';
import 'package:blueray_cargo_assessment/services/auth_service.dart';
import 'package:blueray_cargo_assessment/services/auth_table_provider.dart';
import 'package:blueray_cargo_assessment/services/base_service.dart';
import 'package:blueray_cargo_assessment/services/customer_table_provider.dart';
import 'package:blueray_cargo_assessment/services/register_service.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:blueray_cargo_assessment/views/register_form_page.dart';
import 'package:blueray_cargo_assessment/views/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthViewModel with ChangeNotifier {
  var baseProvider = navigatorKey.currentContext!.read<BaseViewModel>();

  bool _isRegisterPasswordVisible = false;
  bool _isLoginPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isLoginFormValid = false;
  // bool _isFormValid = false;
  // bool _isDataReady = false;

  bool get isRegisterPasswordVisible => _isRegisterPasswordVisible;
  bool get isLoginPasswordVisible => _isLoginPasswordVisible;
  bool get isEmailValid => _isEmailValid;
  bool get isLoginFormValid => _isLoginFormValid;
  // bool get isFormValid => _isFormValid;
  // bool get isDataReady => _isDataReady;

  set isRegisterPasswordVisible(bool newValue) {
    _isRegisterPasswordVisible = newValue;
    notifyListeners();
  }

  set isLoginPasswordVisible(bool newValue) {
    _isLoginPasswordVisible = newValue;
    notifyListeners();
  }

  set isEmailValid(bool newValue) {
    _isEmailValid = newValue;
    notifyListeners();
  }

  set isLoginFormValid(bool newValue) {
    _isLoginFormValid = newValue;
    notifyListeners();
  }
  // set isFormValid(bool newValue) {
  //   _isFormValid = newValue;
  //   notifyListeners();
  // }
  // set isDataReady(bool newValue) {
  //   _isDataReady = newValue;
  //   notifyListeners();
  // }

  Future checkEmail(String email) async {
    RegisterMiniModel requestData = RegisterMiniModel(userId: email);
    ResponseModel response = await RegisterService.registerMini(requestData: requestData);
    if (response.action) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (BuildContext context) => VerifyPage(email: email)),
      );
    } else {
      baseProvider.showErrorDialog(response.message);
    }
  }

  Future verifyEmail(String email, String code) async {
    RegisterVerifyCodeModel requestData = RegisterVerifyCodeModel(userId: email, code: code);
    ResponseModel response = await RegisterService.registerVerifyCode(requestData: requestData);
    if (response.action) {
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (BuildContext context) => RegisterFormPage(email: email)),
      );
    } else {
      baseProvider.showErrorDialog(response.message);
    }
  }

  Future resendCode(String email) async {
    RegisterResendCodeModel requestData = RegisterResendCodeModel(userId: email);
    ResponseModel response = await RegisterService.registerResendCode(requestData: requestData);
    baseProvider.showInfoSnackBar(response.message);
  }

  Future saveRegisterData(RegisterMandatoryModel requestData) async {
    await BaseService.uploadImage(File(requestData.idCardImage)).then((ResponseModel uploadImageResponse) async {
      if (uploadImageResponse.action) {
        requestData.idCardImage = uploadImageResponse.value.toString();
        ResponseModel saveDataResponse = await RegisterService.registerMandatory(requestData: requestData);
        if (saveDataResponse.action) {
          baseProvider.showSingleActionDialog(
            title: "Pendaftaran Berhasil",
            message: "Pendaftaran telah selesai, silahkan login untuk melanjutkan.",
            action: () {
              // Navigator.pushReplacement(
              //   navigatorKey.currentContext!,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => LoginPage()));
            },
            buttonText: "Masuk",
          );
        } else {
          baseProvider.showErrorDialog(saveDataResponse.message);
        }
      } else {
        baseProvider.showErrorDialog(uploadImageResponse.message);
      }
    });
  }

  String? validateName(String? name) {
    if (name == null) {
      return null;
    } else if (name == '') {
      return 'tolong isi nama';
    } else if (name.replaceAll(' ', '').isEmpty) {
      return "nama tidak boleh hanya spasi";
    } else if (name.length > 50) {
      return "nama maksimal 50 karakter";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null) {
      return null;
    } else if (password.isEmpty) {
      return 'password tidak boleh kosong';
    } else if (RegExp(r"\s").hasMatch(password)) {
      return 'password tidak boleh mengandung spasi';
    } else if (!(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{0,}$').hasMatch(password))) {
      return 'password harus mengandung huruf besar, huruf kecil, angka, dan simbol';
    } else if (password.length < 8) {
      return 'password minimal 8 karakter';
    }
    return null;
  }

  String? validateIdCardNumber(String? idCardNumber) {
    BaseViewModel baseViewModel = BaseViewModel();
    if (idCardNumber == null) {
      return null;
    } else if (idCardNumber == '') {
      return 'tolong isi nomor KTP';
    } else if (RegExp(r"\s").hasMatch(idCardNumber)) {
      return "nomor KTP tidak boleh mengandung spasi";
    } else if (!baseViewModel.isNumeric(idCardNumber)) {
      return 'nomor KTPs hanya boleh diisi angka';
    } else if (idCardNumber.length != 16) {
      return 'nomor KTP harus 16 digit';
    }
    return null;
  }

  String? validateIdCardName(String? idCardName) {
    if (idCardName == null) {
      return null;
    } else if (idCardName == '') {
      return 'tolong isi nama di KTP';
    } else if (idCardName.replaceAll(' ', '').isEmpty) {
      return "nama di KTP tidak boleh hanya spasi";
    } else if (idCardName.length > 50) {
      return "nama di KTP maksimal 50 karakter";
    }
    return null;
  }

  String? validateIdCardAddress(String? idCardAddress) {
    if (idCardAddress == null) {
      return null;
    } else if (idCardAddress == '') {
      return 'tolong isi alamat di KTP';
    } else if (idCardAddress.replaceAll(' ', '').isEmpty) {
      return "alamat di KTP tidak boleh hanya spasi";
    }
    return null;
  }

  void checkFormValidity(GlobalKey<FormState> formKey, RegisterMandatoryModel requestData) {
    var baseProvider = navigatorKey.currentContext!.read<BaseViewModel>();
    var image = navigatorKey.currentContext!.read<GetImageViewModel>().tempImage;
    requestData.idCardImage = image!;
    if (formKey.currentState?.validate() == true && baseProvider.isImageExists()) {
      baseProvider.showSingleActionDialog(
        title: "Cek Ulang",
        message: "Anda yakin ingin menyimpan data ini?",
        action: () async => await saveRegisterData(requestData),
        buttonText: "Simpan",
      );
    } else {
      baseProvider.showErrorSnackBar("Tolong isi semua data dengan lengkap");
    }
  }

  void checkEmailValidity(GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() == true) {
      isEmailValid = true;
    } else {
      isEmailValid = false;
    }
  }

  void checkLoginFormValidity(GlobalKey<FormState> formKey) {
    if (formKey.currentState?.validate() == true) {
      isLoginFormValid = true;
    } else {
      isLoginFormValid = false;
    }
  }

  doLogin(LoginRequestModel requestData, GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() == false) {
      throw "Tolong isi data login dengan benar";
    }
    var response = await AuthService.login(requestData: requestData);
    AuthorizationTableProvider authTableProvider = AuthorizationTableProvider();
    CustomerTableProvider customerTableProvider = CustomerTableProvider();
    AuthorizationModel authData = AuthorizationModel(
      token: response.token!,
      tokenExpiryDate: response.tokenExpiryDate!,
    );
    await authTableProvider.insertData(authData);
    await customerTableProvider.insertData(response.customer!);
  }
}
