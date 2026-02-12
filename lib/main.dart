import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pecan_construction/config/bindings/app_bindings.dart';
import 'package:pecan_construction/config/routes/routes.dart';
import 'package:pecan_construction/screens/auth_screens/splash_screens.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, device) {
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
        );
      },
    );
  }
}
