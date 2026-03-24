import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    skipOrShowSplash();
  }

  void skipOrShowSplash() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Already logged in, direct navigate without delay
      final uid = user.uid;

      // Admin check
      final adminDoc = await FirebaseFirestore.instance.collection("admins").doc(uid).get();
      if (adminDoc.exists) {
        Get.offAllNamed(RoutesName.BottomNavScreen);
        return;
      }

      // Employee check
      final employeeDoc = await FirebaseFirestore.instance.collection("employees").doc(uid).get();
      if (employeeDoc.exists) {
        Get.offAllNamed(RoutesName.EmployeeBottomNavScreen);
        return;
      }

      // Fallback
      Get.offAllNamed(RoutesName.RoleSelectionScreen);
    } else {
      // New user → show splash for 2 sec
      await Future.delayed(Duration(seconds: 2));
      await Splash_Controller().checkLogin();
    }
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