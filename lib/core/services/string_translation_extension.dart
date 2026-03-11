import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../main.dart';
import '../localizations/locale_controller.dart';

extension TranslationExtension on String {

  String get trn {

    final localeController = Get.find<LocaleController>();
    final storage = GetStorage();

    /// agar language english hai
    if (localeController.languageCode.value == "en") {
      return this;
    }

    /// cache check
    String key = "tr_${hashCode}";
    String? cached = storage.read(key);

    if (cached != null) {
      return cached;
    }

    /// background translate
    _translateAndSave(this);

    return this;
  }

  void _translateAndSave(String text) async {

    final translated = await translationService.translate(text);

    final storage = GetStorage();

    storage.write("tr_${text.hashCode}", translated);
  }
}