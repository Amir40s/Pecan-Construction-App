import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:sizer/sizer.dart';

import '../../config/routes/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2)  ,(){
      return Get.offNamed(RoutesName.RoleSelectionScreen);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 55.w,
                    height: 9.5.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(AppImages.logoImage))
                    ),
                  ),
                  SizedBox(height: 0.4.h,),
                  AppText("Precision in Every Project", fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black,)
            ]),
          ),
        ),
      ),
    );
  }
}
