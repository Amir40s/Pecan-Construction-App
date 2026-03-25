import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:pecan_construction/screens/auth_screens/controllers/splash_controller.dart';
import 'package:sizer/sizer.dart';

import '../../config/routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Splash_Controller c = Get.put(Splash_Controller());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      skipOrShowSplash();
    });
  }

  void skipOrShowSplash() async {
    final box = GetStorage();

    // Check if admin previously logged in
    final savedAdminEmail = box.read<String>('logged_in_admin_email');
    if (savedAdminEmail != null) {
      Get.offAllNamed(RoutesName.BottomNavScreen); // admin home
      return;
    }

    // Check FirebaseAuth for employees
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      final employeeDoc = await FirebaseFirestore.instance
          .collection("employees")
          .doc(uid)
          .get();

      if (employeeDoc.exists) {
        Get.offAllNamed(RoutesName.EmployeeBottomNavScreen);
        return;
      }
    }

    // If neither admin nor employee → role selection
    Get.offAllNamed(RoutesName.RoleSelectionScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 55.w,
                  height: 9.5.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.logoImage),
                    ),
                  ),
                ),
                SizedBox(height: 0.4.h),
                AppText(
                  "Precision in Every Project",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}