import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/dialog_foreground_process_model.dart';
import 'package:blueray_cargo_assessment/services/auth_table_provider.dart';
import 'package:blueray_cargo_assessment/services/db_context.dart';
import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blueray_cargo_assessment/global.dart' as global;

class BaseViewModel with ChangeNotifier {
  String? _authToken;
  final String _accessToken =
      "token";

  String? get authToken => _authToken;
  String get accessToken => _accessToken;

  set authToken(String? newValue) {
    _authToken = newValue;
    notifyListeners();
  }

  showErrorDialog(String errorMessage) {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(title: Text("Oops"), content: Text(errorMessage));
      },
    );
  }

  showSingleActionDialog({
    required String title,
    required String message,
    required Function action,
    required String buttonText,
  }) {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [ElevatedButton(onPressed: () => action(), child: Text(buttonText))],
        );
      },
    );
  }

  void showInfoSnackBar(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message), backgroundColor: Colors.blue);

    ScaffoldMessenger.of(navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  void showErrorSnackBar(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red);

    ScaffoldMessenger.of(navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  bool isImageExists() {
    var getImageProvider = navigatorKey.currentContext!.read<GetImageViewModel>();
    if (getImageProvider.tempImage != null && File(getImageProvider.tempImage!).existsSync()) {
      return true;
    }
    return false;
  }

  shimmerForegroundProcess(Function process) async {
    try {
      await process();
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  dialogForegroundProcess(Function process, DialogForegroundProcessModel dialogData) async {
    showLoadingDialog();
    try {
      await process();
      Navigator.of(navigatorKey.currentContext!).pop();
      showSingleActionDialog(
        title: dialogData.title,
        message: dialogData.message,
        action: dialogData.action,
        buttonText: dialogData.buttonText,
      );
    } catch (e) {
      Navigator.of(navigatorKey.currentContext!).pop();
      showErrorDialog(e.toString());
    }
  }

  navigateForegroundProcess(Function process, Widget nextPage) async {
    showLoadingDialog();
    try {
      await process();
      Navigator.of(navigatorKey.currentContext!).pop();
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (BuildContext context) => nextPage),
      );
    } catch (e) {
      Navigator.of(navigatorKey.currentContext!).pop();
      showErrorDialog(e.toString());
    }
  }

  showLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            child: Container(
              height: 200,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 15), Text("mohon tunggu")],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onLaunch() async {
    AuthorizationTableProvider authTableProvider = AuthorizationTableProvider();
    await DbContext.instance.database;
    var authData = await authTableProvider.getData();
    if (authData.isEmpty) {
      isLoggedIn = false;
    } else {
      if (authData.first.tokenExpiryDate.compareTo(DateTime.now()) == -1) {
        isLoggedIn = false;
      } else {
        global.authToken = authData.first.token;
        isLoggedIn = true;
      }
    }
  }

  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null) {
      return null;
    } else if (phoneNumber == '') {
      return 'tolong isi nomor telepon';
    } else if (RegExp(r"\s").hasMatch(phoneNumber)) {
      return "nomor telepon tidak boleh mengandung spasi";
    } else if (!isNumeric(phoneNumber)) {
      return 'nomor telepon hanya boleh diisi angka';
    } else if (phoneNumber.length < 10) {
      return 'nomor telepon minimal 10 digit';
    } else if (phoneNumber.length > 15) {
      return 'nomor telepon maksimal 15 digit';
    }
    return null;
  }

  bool isNumeric(String s) {
    return int.tryParse(s) == null ? false : true;
  }

  String? validateAddress(String? idCardAddress) {
    if (idCardAddress == null) {
      return null;
    } else if (idCardAddress == '') {
      return 'tolong isi alamat';
    } else if (idCardAddress.replaceAll(' ', '').isEmpty) {
      return "alamat tidak boleh hanya spasi";
    }
    return null;
  }

  String? validateEmail(String? email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (email == null) {
      return null;
    } else if (email == '') {
      return 'tolong isi email';
    } else if (!regex.hasMatch(email)) {
      return 'email tidak valid';
    }
    return null;
  }

  String? validateTaxIDNumber(String? idCardNumber) {
    if (idCardNumber == null) {
      return null;
    } else if (idCardNumber == '') {
      return 'tolong isi nomor NPWP';
    } else if (RegExp(r"\s").hasMatch(idCardNumber)) {
      return "nomor NPWP tidak boleh mengandung spasi";
    } else if (!isNumeric(idCardNumber)) {
      return 'nomor NPWP hanya boleh diisi angka';
    } else if (idCardNumber.length != 16) {
      return 'nomor NPWP harus 16 digit';
    }
    return null;
  }

  String? validatePlainText(String? text, String formName, int maxChar) {
    if (text == null) {
      return null;
    } else if (text == '') {
      return 'tolong isi $formName';
    } else if (text.replaceAll(' ', '').isEmpty) {
      return "$formName tidak boleh hanya spasi";
    } else if (text.length > maxChar) {
      return "$formName maksimal $maxChar karakter";
    }
    return null;
  }
}
