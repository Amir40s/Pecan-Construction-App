import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService extends GetxService {

  late OnDeviceTranslator translator;

  Future<TranslationService> init() async {

    translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.german,
    );

    return this;
  }

  Future<String> translate(String text) async {

    if (Get.locale?.languageCode != 'de') {
      return text;
    }

    try {
      return await translator.translateText(text);
    } catch (e) {
      return text;
    }
  }
}