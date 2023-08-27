import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String languageCode = 'languageCode';
const String english = 'en';
const String turkish = 'tr';

/// Verilen dil koduna göre bir [Locale] nesnesi oluşturan yardımcı fonksiyon.
Locale _locale(String? languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, "EN");
    case turkish:
      return const Locale(turkish, "TR");
    default:
      return const Locale(english, "EN");
  }
}

/// Tercih edilen dili ayarlamak için kullanılan asenkron fonksiyon.
///
/// [langCode] - Ayarlanacak olan dil kodu.
///
/// Geri Dönüş: Ayarlanan [Locale] nesnesi.
Future<Locale> setLocale(String langCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(languageCode, langCode);
  return _locale(langCode);
}

/// Kaydedilmiş tercih edilen dili almak için kullanılan asenkron fonksiyon.
///
/// Geri Dönüş: Kaydedilmiş tercih edilen [Locale] nesnesi, eğer yoksa `null`.
Future<Locale?> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? langCode = prefs.getString(languageCode);
  if (langCode == null) {
    return null;
  } else {
    return _locale(langCode);
  }
}
