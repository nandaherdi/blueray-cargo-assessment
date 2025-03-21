import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/register_mandatory_model.dart';
import 'package:blueray_cargo_assessment/models/register_mini_model.dart';
import 'package:blueray_cargo_assessment/models/register_resend_code_model.dart';
import 'package:blueray_cargo_assessment/models/register_verify_code_model.dart';
import 'package:blueray_cargo_assessment/models/response_model.dart';
import 'package:blueray_cargo_assessment/services/base_service.dart';
import 'package:blueray_cargo_assessment/services/register_service.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:blueray_cargo_assessment/views/register_form_page.dart';
import 'package:blueray_cargo_assessment/views/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterViewModel with ChangeNotifier {
  var baseProvider = navigatorKey.currentContext!.read<BaseViewModel>();

  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  set setPasswordVisibility(bool newValue) {
    _isPasswordVisible = newValue;
    notifyListeners();
  }

  Future checkEmail(String email) async {
    RegisterMiniModel requestData = RegisterMiniModel(userId: email);
    ResponseModel response = await RegisterService.registerMini(requestData: requestData);
    if (response.action) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (BuildContext context) => VerifyPage(email: email)));
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
        MaterialPageRoute(
          builder: (BuildContext context) => RegisterFormPage(email: email,)));
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
            action: (){
              // Navigator.pushReplacement(
              //   navigatorKey.currentContext!,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => LoginPage()));
            },
            buttonText: "Masuk"
          );
        } else {
          baseProvider.showErrorDialog(saveDataResponse.message);
        }
      } else {
        baseProvider.showErrorDialog(uploadImageResponse.message);
      }
    });
  }
}