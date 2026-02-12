import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:pecan_construction/core/widgets/app_text_field.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:pecan_construction/core/widgets/language_switcher.dart';
import 'package:sizer/sizer.dart';

class SigninScreen extends StatefulWidget {
   SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final emailC = TextEditingController();

  final passwordC = TextEditingController();

   String selectedLang = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(
        horizontal: 3.w, vertical: 1.h
      ), child: Column(
        children: [
          CustomHeader(title: "Sign In",showBack: false,),
          SizedBox(height: 7.h,),
          Container(
            width: 95.w,
            height: 70.h,
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
                AppText("Build Manager", fontSize: 30,fontWeight: FontWeight.w700,color: Color(0xffC22522),),
                // SizedBox(height : 1.h),
                AppText("Enter your credentials to manage your site", fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff979796),)
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
                 SizedBox(height : 3.h),
                 AppText("Password", fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                 SizedBox(height: 1.h,),
                 AppFormField(
                   preficIconwidth: 10,
                   prefixIconheight: 10,
                   prefic_icons: SvgPicture.asset(AppIcons.lockIcon,),
                   showPretixIcon: true,
                   title: "******", textEditingController: passwordC,
                   showBorder: true,
                   borderColor: Color(0xffDC9291),
                 ),
                 SizedBox(height: 2.h,),
                 GestureDetector(
                   onTap: (){
                     Get.toNamed(RoutesName.forgotPassword);
                   },
                   child: Align(
                     alignment: Alignment.centerRight,
                       child: AppText("Forget Password", fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xffC22522),)),
                 ),

                 SizedBox(height: 4.h,),
                 AppButtonWidget(
                      onPressed: (){
                        Get.toNamed(RoutesName.BottomNavScreen);
                      },
                   fontSize: 18,
                   fontWeight: FontWeight.w600,
                   width: 70.w,
                     height: 8.h,
                     buttonColor: Color(0xffC22522),
                     text: "SignIn"),
                 SizedBox(height: 1.h,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     AppText("Don't have an account?",fontWeight: FontWeight.w800,fontSize: 14,),
                     SizedBox(width: 1.w,),
                     GestureDetector(
                       onTap: (){
                         Get.toNamed(RoutesName.signup,);

                       },
                         child: AppText("Sign Up", fontWeight: FontWeight.w900,fontSize: 15,color: Color(0xffC22522),))
                   ],
                 ),

               ],
             ),

              ],
            ),
          ),
          SizedBox(height: 3.h,),
          LanguageSwitcher(selectedLanguage: "English", onChanged: (value){
            setState(() {
              selectedLang = value;
            });
          }),
        ],
      ),)),
    );
  }
}
