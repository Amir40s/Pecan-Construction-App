import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {

  final storage = GetStorage();

  RxString languageCode = "en".obs;

  Locale get locale => Locale(languageCode.value);
  bool get isGerman => languageCode.value == "de";
  @override
  void onInit() {
    loadSavedLanguage();
    super.onInit();
  }

  void changeLanguage(String langCode) {

    languageCode.value = langCode;

    if (langCode == "de") {
      Get.updateLocale(const Locale('de', 'DE'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }

    storage.write("language", langCode);
  }

  void loadSavedLanguage() {

    String? lang = storage.read("language");

    if (lang != null) {
      languageCode.value = lang;
    }

    changeLanguage(languageCode.value);
  }
}