import 'package:flutter/material.dart';

/// Yardımcı işlevleri içeren [UIHelper] sınıfı, kullanıcı arayüzü
/// bileşenlerinin boyutları ve özellikleriyle ilgili işlemleri
/// kolaylaştırmak için geliştirilmiştir.
class UIHelper {
  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static isDevicePortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ? true : false;
  }

  static List<BoxShadow>? boxShadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 1,
      blurRadius: 5,
      offset: const Offset(0, 1),
    ),
  ];
}
