import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bu sınıf, proje genelinde ortak olarak kullanılabilecek fonksiyonları içermektedir.
class AppFunctions {
  /// Bu fonksiyon kullanıcıya geri bildirim vermek için kullanılır. Toast mesajlardan farkı, daha çok kişiselleştirilebilir olması ve Toast mesajların aksine bir yenisi oluştuğunda bir öncekini otomatik olarak sonlandırır.
  static void showSnackbar(BuildContext context, String text,
      {Color? backgroundColor, IconData? icon, int duration = 2}) {
    final snackbar = SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      ),
      content: Row(
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  child: Icon(icon, size: 24, color: Colors.white),
                )
              : const SizedBox(),
          Expanded(
            child: Text(
              text,
              textAlign: icon != null ? TextAlign.start : TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: backgroundColor != null ? backgroundColor.withOpacity(1) : Colors.grey.withOpacity(1),
      duration: Duration(seconds: duration),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  /// Bu fonksiyon kullanıcıya kamera ve galeriye erişmek için bir arayüz sunar ve belirlenen süre sonunda kaybolur.
  void showMediaSnackbar(BuildContext context, Function cameraFunction, Function galleryFunction) {
    final snackbar = SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: UIHelper.getDeviceWidth(context) / 4,
            height: UIHelper.getDeviceWidth(context) / 4,
            child: IconButton(
              splashColor: splashColor,
              iconSize: UIHelper.getDeviceWidth(context) / 8,
              onPressed: () {
                cameraFunction();
              },
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
            ),
          ),
          SizedBox(
            width: UIHelper.getDeviceWidth(context) / 4,
            height: UIHelper.getDeviceWidth(context) / 4,
            child: IconButton(
              splashColor: splashColor,
              iconSize: UIHelper.getDeviceWidth(context) / 8,
              onPressed: () {
                galleryFunction();
              },
              icon: Icon(
                Icons.image,
                color: Colors.white,
                size: UIHelper.getDeviceWidth(context) / 8,
              ),
            ),
          )
        ],
      ),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: primaryColor,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  /// Bu fonksiyon cihaz galerisinden seçilen görseli File? tipinde geri döndürür.
  Future<File?> pickImageFromGallery() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    try {
      PermissionStatus permissionStatus = PermissionStatus.denied;
      if (int.parse(androidInfo.version.release) >= 12) {
        await Permission.photos.request();
        permissionStatus = await Permission.photos.status;
      } else {
        await Permission.storage.request();
        permissionStatus = await Permission.storage.status;
      }
      if (permissionStatus.isGranted) {
        try {
          final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100, maxWidth: 1920);
          if (image == null) return null;
          final imageTemp = File(image.path);
          return imageTemp;
        } on PlatformException catch (e) {
          throw Exception([e]);
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception([e]);
    }
  }

  /// Bu fonksiyon cihaz kamerası ile anlık çekilen görseli File? tipinde geri döndürür.
  Future<File?> pickImageFromCamera() async {
    try {
      await Permission.camera.request();
      var permissionStatus = await Permission.camera.status;
      if (permissionStatus.isGranted) {
        try {
          final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 100, maxWidth: 1920);
          if (image == null) return null;
          final imageTemp = File(image.path);
          return imageTemp;
        } on PlatformException catch (e) {
          throw Exception([e]);
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception([e]);
    }
  }

  /// Bu fonksiyon File tipindeki veriyi base64 olarak kodlar ve değeri String olarak geri döndürür.
  static String convertToBase64(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    final base64String = base64Encode(bytes);
    return base64String;
  }
}
