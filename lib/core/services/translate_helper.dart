import 'package:get/get.dart';
import '../../main.dart';
import '../localizations/locale_controller.dart';

Future<String> trText(String text) async {

  final localeController = Get.find<LocaleController>();

  /// agar english selected hai
  if (!localeController.isGerman) {
    return text;
  }

  /// agar german hai
  return await translationService.translate(text);
}