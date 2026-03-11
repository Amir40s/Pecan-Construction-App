import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {

  final storage = GetStorage();

  late OnDeviceTranslator _translator;

  Future<void> init() async {

    _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.german,
    );
  }

  Future<String> translate(String text) async {

    /// agar already german ho to return
    if (_isGerman(text)) {
      return text;
    }

    /// cache check
    String key = "tr_${text.hashCode}";

    String? cached = storage.read(key);

    if (cached != null) {
      return cached;
    }

    /// translate
    String translated = await _translator.translateText(text);

    /// save cache
    storage.write(key, translated);

    return translated;
  }

  bool _isGerman(String text) {

    /// simple detection
    return text.contains("ä") ||
        text.contains("ö") ||
        text.contains("ü") ||
        text.contains("ß");
  }

  void dispose() {
    _translator.close();
  }
}