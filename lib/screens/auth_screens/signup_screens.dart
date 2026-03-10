import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/core/widgets/language_switcher.dart';
import 'package:pecan_construction/screens/auth_screens/controllers/signup_controller.dart';
import 'package:sizer/sizer.dart';
import '../../core/constant/app_icons.dart';
import '../../core/constant/app_images.dart';
import '../../core/localizations/locale_controller.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/header_widget.dart';

class SignUpScreens extends GetView<SignUpController> {
   SignUpScreens({super.key});
   final localeController = Get.find<LocaleController>();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(children: [
              CustomHeader(title: "signup_title".tr),
              SizedBox(height: 2.h,),
              Container(
                width: 95.w,
                height: 82.h,
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
                    AppText("signup_heading".tr, fontSize: 25,fontWeight: FontWeight.w700,color: Color(0xffC22522),),
                    // SizedBox(height : 1.h),
                    AppText("signup_description".tr,textAlign: TextAlign.center, fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff979796),)
                    ,  SizedBox(height : 2.h),
                    Form(
                      key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText("full_name", fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                            SizedBox(height: 1.h,),
                            AppFormField(
                              validator: (value) {
                                if(value!.isEmpty || value.length < 3){
                                  return "invalid_name".tr;
                                }
                                return null;
                              },
                              preficIconwidth: 10,
                              prefixIconheight: 10,
                              prefic_icons: SvgPicture.asset(AppIcons.personIcon,),
                              showPretixIcon: true,
                              title: "name_hint".tr, textEditingController: controller.nameC,
                              showBorder: true,
                              borderColor: Color(0xffDC9291),

                            ),
                            SizedBox(height : 2.h),
                            AppText("business_email".tr, fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                            SizedBox(height: 1.h,),
                            AppFormField(
                              validator: (value) {
                                if(value== null || value.isEmpty){
                                  return  "email_required".tr;
                                }
                                if(!GetUtils.isEmail(value)){
                                  return "invalid_email";
                                }
                                return null;
                              },
                              preficIconwidth: 10,
                              prefixIconheight: 10,
                              prefic_icons: SvgPicture.asset(AppIcons.emailIcon,),
                              showPretixIcon: true,
                              title: "info@gmail.com", textEditingController: controller.emailC,
                              showBorder: true,
                              borderColor: Color(0xffDC9291),
                            ),
                            SizedBox(height : 2.h),
                            AppText("password".tr, fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black,),
                            SizedBox(height: 1.h,),
                           Obx((){
                             return  AppFormField(
                               validator: (value) {
                                 if(value == null || value.isEmpty){
                                   return "password_required".tr;
                                 }
                                 if(value.length < 6){
                                   return "password_length".tr;
                                 }
                                 return null;
                               },
                               iconWidget: InkWell(
                                 onTap: controller.togglePassword,
                                 child: Icon(
                                   controller.isPasswordVisible.value
                                       ? Icons.visibility_off
                                       : Icons.visibility,
                                   color: Colors.redAccent,
                                 ),
                               ),
                               isObsecured: controller.isPasswordVisible.value,
                               preficIconwidth: 10,
                               prefixIconheight: 10,
                               prefic_icons: SvgPicture.asset(AppIcons.lockIcon,),
                               showPretixIcon: true,
                               title: "******", textEditingController: controller.passwordC,
                               showBorder: true,
                               borderColor: Color(0xffDC9291),
                             );
                           }),
                            SizedBox(height: 4.h,),
                            Obx((){
                              return AppButtonWidget(
                                  onPressed: (){
                                    controller.SignUpEmployee();
                                  },
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  width: 70.w,
                                  loader: controller.isLoading.value,
                                  height: 8.h,
                                  buttonColor: Color(0xffC22522),
                                  text: "create_account".tr);
                            }
                            ),
                            SizedBox(height: 1.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText("already_account".tr,fontWeight: FontWeight.w800,fontSize: 14,),
                                SizedBox(width: 1.w,),
                                InkWell(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                    child: AppText("signin".tr, fontWeight: FontWeight.w900,fontSize: 15,color: Color(0xffC22522),))
                              ],
                            ),

                          ],
                        ),
                    )

                  ],
                ),
              ),
              LanguageSwitcher(
                selectedLanguage:
                localeController.locale.languageCode == "de" ? "German" : "English",
                onChanged: (value) {

                  if (value == "English") {
                    localeController.changeLanguage("en");
                  } else {
                    localeController.changeLanguage("de");
                  }

                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
