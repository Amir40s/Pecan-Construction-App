import 'package:get/get.dart';
import 'languages/en.dart';
import 'languages/de.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en,
    'de_DE': de,
  };
}