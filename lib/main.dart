import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pecan_construction/config/routes/routes.dart';
import 'package:pecan_construction/core/services/notification_services.dart';
import 'package:pecan_construction/screens/auth_screens/splash_screens.dart';
import 'package:sizer/sizer.dart';
import 'core/localizations/app_translations.dart';
import 'core/localizations/locale_controller.dart';
import 'core/services/translation_service.dart';
import 'firebase_options.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background Notification: ${message.notification?.title}");
}

final TranslationService translationService = TranslationService();

void main()  async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await GetStorage.init();

  final NotificationService notificationService = NotificationService();
  await notificationService.setup();


  await translationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, device) {
        final LocaleController localeController = Get.put(LocaleController());

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
           scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          initialRoute: "/",
          getPages: AppRoutes.routes,
          // initialBinding: GlobalBinding(),
          home: SplashScreen(),
          translations: AppTranslations(),
          locale: localeController.locale,
          fallbackLocale: const Locale('en', 'US'),
        );
      },
    );
  }
}
