import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/widgets/language_switcher.dart';
import 'package:pecan_construction/screens/auth_screens/controllers/signup_controller.dart';
import 'package:sizer/sizer.dart';

import '../../config/routes/routes_name.dart';
import '../../core/constant/app_icons.dart';
import '../../core/constant/app_images.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/header_widget.dart';

class SignUpScreens extends GetView<SignUpController> {
   SignUpScreens({super.key});
  String selectedLang = "English";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(children: [
              CustomHeader(title: "Sign Up"),
              SizedBox(height: 5.h,),
              Container(
                width: 95.w,
                height: 75.h,
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
                    AppText("Join Build Manager", fontSize: 30,fontWeight: FontWeight.w700,color: Color(0xffC22522),),
                    // SizedBox(height : 1.h),
                    AppText("Start managing your construction projects effectively",textAlign: TextAlign.center, fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff979796),)
                    ,  SizedBox(height : 2.h),
                    Form(
                      key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText("Full Name", fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                            SizedBox(height: 1.h,),
                            AppFormField(

                              preficIconwidth: 10,
                              prefixIconheight: 10,
                              prefic_icons: SvgPicture.asset(AppIcons.personIcon,),
                              showPretixIcon: true,
                              title: "infoDev", textEditingController: controller.nameC,
                              showBorder: true,
                              borderColor: Color(0xffDC9291),

                            ),
                            SizedBox(height : 2.h),
                            AppText("Business Email", fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                            SizedBox(height: 1.h,),
                            AppFormField(
                              preficIconwidth: 10,
                              prefixIconheight: 10,
                              prefic_icons: SvgPicture.asset(AppIcons.emailIcon,),
                              showPretixIcon: true,
                              title: "info@gmail.com", textEditingController: controller.emailC,
                              showBorder: true,
                              borderColor: Color(0xffDC9291),
                            ),
                            SizedBox(height : 2.h),
                            AppText("Password", fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                            SizedBox(height: 1.h,),
                            AppFormField(
                              preficIconwidth: 10,
                              prefixIconheight: 10,
                              prefic_icons: SvgPicture.asset(AppIcons.lockIcon,),
                              showPretixIcon: true,
                              title: "******", textEditingController: controller.passwordC,
                              showBorder: true,
                              borderColor: Color(0xffDC9291),
                            ),
                            SizedBox(height: 4.h,),
                            AppButtonWidget(
                                onPressed: (){

                                controller.SignUp();                                },
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                width: 70.w,
                                height: 8.h,
                                buttonColor: Color(0xffC22522),
                                text: "Create Account"),
                            SizedBox(height: 1.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText("Already have an account?",fontWeight: FontWeight.w800,fontSize: 14,),
                                SizedBox(width: 1.w,),
                                InkWell(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                    child: AppText("Sign In", fontWeight: FontWeight.w900,fontSize: 15,color: Color(0xffC22522),))
                              ],
                            ),

                          ],
                        ),
                    )

                  ],
                ),
              ),
              SizedBox(height: 1.5.h,),
              LanguageSwitcher(selectedLanguage: selectedLang, onChanged: (val){
                selectedLang = val;
              })
            ]),
          ),
        ),
      ),
    );
  }
}
