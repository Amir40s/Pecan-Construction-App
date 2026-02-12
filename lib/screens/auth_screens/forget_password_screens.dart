import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../config/routes/routes_name.dart';
import '../../core/constant/app_icons.dart';
import '../../core/constant/app_images.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/header_widget.dart';
import '../../core/widgets/language_switcher.dart';

class ForgetPasswordScreens extends StatelessWidget {
   ForgetPasswordScreens({super.key});

  String selectedLang = "English";
   final emailC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: Column(children: [
            CustomHeader(title: "Forget Password"),
            SizedBox(height: 13.h,),
            Container(
              width: 95.w,
              height: 54.h,
              padding: EdgeInsets.only(top: 25, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: BoxBorder.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    width : 37.w,
                    height: 8.h,
                    child: Image.asset(AppImages.logoImage),
                  ),
                  SizedBox(height : 1.h),
                  AppText("Reset Password", fontSize: 30,fontWeight: FontWeight.w700,color: Color(0xffC22522),),
                  // SizedBox(height : 1.h),
                  AppText("Enter your email address and we’ll send you a link to reset your password.", textAlign: TextAlign.center,fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff979796),)
                  ,  SizedBox(height : 4.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText("Email Address", fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                      SizedBox(height: 1.h,),
                      AppFormField(

                        preficIconwidth: 10,
                        prefixIconheight: 10,
                        prefic_icons: SvgPicture.asset(AppIcons.emailIcon,),
                        showPretixIcon: true,
                        title: "info@gmail.com", textEditingController: emailC,
                        showBorder: true,
                        borderColor: Color(0xffDC9291),

                      ),
                      SizedBox(height: 4.h,),
                      AppButtonWidget(
                          onPressed: (){
                            Get.toNamed(RoutesName.signup,);
                          },
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          width: 70.w,
                          height: 8.h,
                          buttonColor: Color(0xffC22522),
                          text: "Send Code"),
                      SizedBox(height: 1.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText("Return to",fontWeight: FontWeight.w800,fontSize: 14,),
                          SizedBox(width: 1.w,),
                          AppText("Sign In", fontWeight: FontWeight.w900,fontSize: 15,color: Color(0xffC22522),)
                        ],
                      ),

                    ],
                  ),

                ],
              ),
            ),
            SizedBox(height: 3.h,),
            LanguageSwitcher(selectedLanguage: "English", onChanged: (value){
              selectedLang = value;

            }),


          ]),
        ),
      ),
    );
  }
}
