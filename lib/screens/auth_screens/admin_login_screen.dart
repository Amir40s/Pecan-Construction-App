import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_icons.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/app_buttons.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:pecan_construction/core/widgets/app_text_field.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import 'package:pecan_construction/core/widgets/language_switcher.dart';
import 'package:pecan_construction/screens/employ_screens/controllers/adminLogincontroller.dart';
import 'package:sizer/sizer.dart';

import '../../core/localizations/locale_controller.dart';


class adminLoginScreen extends GetView<AdminLoginController> {
  adminLoginScreen({super.key});

  // String selectedLang = "English";
  final localeController = Get.find<LocaleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(child: Padding(padding: EdgeInsets.symmetric(
            horizontal: 3.w, vertical: 1.h
        ), child: Column(
          children: [
            CustomHeader(title: "signin_title".tr,showBack: false,),
            SizedBox(height: 3.h,),
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
                  AppText("app_name".tr, fontSize: 30,fontWeight: FontWeight.w700,color: Color(0xffC22522),),
                  // SizedBox(height : 1.h),
                AppText(
                  "login_description".tr,
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff979796),
                ),                    SizedBox(height : 4.h),
                  Form(
                      key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText("email_address".tr, fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                        SizedBox(height: 1.h,),
                        AppFormField(
                          validator: (value){
                            if(value!.isEmpty) return "email_required".tr;
                            if(!GetUtils.isEmail(value)) return "invalid_email".tr;
                            return null;
                          },
                          preficIconwidth: 10,
                          prefixIconheight: 10,
                          prefic_icons: SvgPicture.asset(AppIcons.emailIcon,),
                          showPretixIcon: true,
                          title: "email_hint".tr,
                          textEditingController: controller.emailC,
                          showBorder: true,
                          borderColor: Color(0xffDC9291),

                        ),
                        SizedBox(height : 3.h),
                        AppText("password".tr, fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                        SizedBox(height: 1.h,),
                        Obx((){
                          return AppFormField(
                            validator: (value){
                              if(value!.isEmpty)return "password_required".tr;
                              if(value.length < 6) return "password_required".tr;
                              return null;
                            },
                            preficIconwidth: 10,
                            prefixIconheight: 10,
                            prefic_icons: SvgPicture.asset(AppIcons.lockIcon,),
                            showPretixIcon: true,
                            iconWidget: InkWell(
                              onTap:  controller.togglePassword,
                              child: Icon(
                                controller.isPasswordVisible.value ?
                                Icons.visibility_off :
                                Icons.visibility_sharp, color: Colors.redAccent,),
                            ),

                            isObsecured: controller.isPasswordVisible.value,
                            title: "******",
                            textEditingController: controller.passwordC,
                            showBorder: true,
                            borderColor: Color(0xffDC9291),
                          );
                        }
                        ),

                        SizedBox(height: 4.h,),
                        Obx((){
                          return AppButtonWidget(
                              onPressed: controller.isLoggingIn.value ? null :  (){
                                if (controller.formKey.currentState!.validate()) {
                                  controller.loginAdmin();
                                }
                              },
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              width: 70.w,
                              loader:  controller.isLoggingIn.value ,
                              height: 8.h,
                              buttonColor: Color(0xffC22522),
                              text: "signin_button".tr);
                        }),
                        SizedBox(height: 1.h,),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 3.h,),
            Obx(() {
              return LanguageSwitcher(
                selectedLanguage:
                localeController.languageCode.value == "de"
                    ? "German"
                    : "English",
                onChanged: (value) {
                  if (value == "English") {
                    localeController.changeLanguage("en");
                  } else {
                    localeController.changeLanguage("de");
                  }
                },
              );
            })
          ],
        ),)),
      ),
    );
  }
}
