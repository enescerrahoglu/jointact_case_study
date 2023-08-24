import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFunctions {
  static void showSnackbar(BuildContext context, String text,
      {Color? backgroundColor, IconData? icon, int duration = 2}) {
    final snackbar = SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10)),
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
      backgroundColor: backgroundColor != null
          ? backgroundColor.withOpacity(1)
          : Colors.grey.withOpacity(1),
      duration: Duration(seconds: duration),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  showProgressDialog(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (context) {
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  void showMediaSnackbar(
      BuildContext context, Function cameraFunction, Function galleryFunction) {
    final snackbar = SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: UIHelper.getDeviceWidth(context) / 4,
            height: UIHelper.getDeviceWidth(context) / 4,
            child: IconButton(
              splashColor: Colors.deepPurple.shade300,
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
              splashColor: Colors.deepPurple.shade300,
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
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  Future<File?> pickImageFromGallery() async {
    try {
      PermissionStatus permissionStatus = PermissionStatus.denied;
      await Permission.photos.request();
      permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        try {
          final image = await ImagePicker().pickImage(
              source: ImageSource.gallery, imageQuality: 100, maxWidth: 1920);
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

  Future<File?> pickImageFromCamera() async {
    try {
      await Permission.camera.request();
      var permissionStatus = await Permission.camera.status;
      if (permissionStatus.isGranted) {
        try {
          final image = await ImagePicker().pickImage(
              source: ImageSource.camera, imageQuality: 100, maxWidth: 1920);
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
}
