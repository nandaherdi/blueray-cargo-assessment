import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class GetImageViewModel with ChangeNotifier {
  String? _tempImage;
  
  String? get tempImage => _tempImage;

  set tempImage(String? newValue) {
    _tempImage = newValue;
    notifyListeners();
  }

  clearProvider() {
    tempImage = null;
  }

  showImage() {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Scaffold(
          body: Center(
            child: Image.file(File(tempImage!)),
          ),
          bottomNavigationBar: BottomAppBar(
            child: OutlinedButton(
              onPressed: showSelectImageSourceDialog,
              child: Text("ganti gambar")
            ),
          ),
        );
      });
  }

  showSelectImageSourceDialog() {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return SimpleDialog(
          title: Text("Pilih Sumber Gambar"),
          children: [
            SimpleDialogOption(
              onPressed: getImageFromCamera,
              child: Text("Kamera"),
            ),
            SimpleDialogOption(
              onPressed: getImageFromGallery,
              child: Text("Galeri"),
            )
          ],
        );
      }
    );
  }

  getImageFromCamera() {
    showCheckingCameraPermissionDialog();
    checkCameraPermission().then((bool isGranted) async {
      if (!isGranted) {
        showCameraPermissionSettingsDialog();
      } else {
        XFile? photo = await useCamera();
        tempImage = photo?.path;
      }
    });
  }

  getImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );
    tempImage = photo?.path;
  }

  showCheckingCameraPermissionDialog() {
    showModalBottomSheet(
      enableDrag: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Checking camera usage permission..."),
              SizedBox(
                height: 15,
              ),
              LinearProgressIndicator(),
              SizedBox(
                height: 15,
              )
            ],
          ),
        );
      });
  }

  Future<bool> checkCameraPermission() async {
    bool cameraPermissionGranted = false;
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;
    if (cameraPermissionStatus == PermissionStatus.denied) {
      PermissionStatus status = await Permission.camera.request();
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.restricted) {
        cameraPermissionGranted = false;
      } else {
        cameraPermissionGranted = true;
      }
    } else if (cameraPermissionStatus == PermissionStatus.permanentlyDenied) {
      cameraPermissionGranted = false;
    } else if (cameraPermissionStatus == PermissionStatus.restricted) {
      PermissionStatus status = await Permission.camera.request();
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.restricted) {
        cameraPermissionGranted = false;
      } else {
        cameraPermissionGranted = true;
      }
    } else {
      cameraPermissionGranted = true;
    }

    return cameraPermissionGranted;
  }

  showCameraPermissionSettingsDialog() {
    BuildContext context = navigatorKey.currentContext!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Akses Kamera Dibutuhkan"),
          content: const Text("Aplikasi ini membutuhkan akses ke kamera. Jika tetap ingin menggunakan fitur ini, tolong kunjungi setting dan izinkan penggunaan kamera."),
            actions: [
              TextButton(
                  onPressed: () async {
                    await openAppSettings().then((_) {
                      getImageFromCamera();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Go to Settings"))
            ],
          );
        });
  }

  Future<XFile?> useCamera() async {
    final Directory appSupportDirectory = await getApplicationSupportDirectory();
    ImagePicker picker = ImagePicker();
    XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50
    );
    if (photo != null) {
      String fileName = '${Uuid().v1()}.jpg';
      await photo.saveTo('$appSupportDirectory/$fileName');
      await File(photo.path).delete();
    }
    return photo;
  }
  
}