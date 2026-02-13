import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';
import 'package:sizer/sizer.dart';
import '../../core/constant/app_icons.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';

class EmployeeProfileScreens extends StatelessWidget {
  EmployeeProfileScreens({super.key});
  final emailC = TextEditingController();

  final passwordC = TextEditingController();
  final NameC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: 40.w,),
                    AppText("profile", fontSize: 23, fontWeight: FontWeight.w900),
                    Spacer(),
                    IconButton(onPressed: (){
                      Get.toNamed(RoutesName.EmployeeSettingScreen);
                    } , icon: Icon(Icons.settings,color: Colors.black87,size: 35,))
                  ],
                ),
                SizedBox(height: 3.h),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(AppImages.profileImage),
                ),
                SizedBox(height: 1.h),

                AppText("Admin", fontSize: 20, fontWeight: FontWeight.w900),
                SizedBox(height: 3.h),
                Divider(color: Colors.grey.shade200),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      AppText(
                        "Full Name",
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      SizedBox(height: 1.h),
                      AppFormField(
                        preficIconwidth: 10,
                        prefixIconheight: 10,
                        prefic_icons: SvgPicture.asset(AppIcons.personIcon),
                        showPretixIcon: true,
                        title: "Uzair khan",
                        textEditingController: NameC,
                        showBorder: true,
                        borderColor: Color(0xffDC9291),
                      ),
                      SizedBox(height: 3.h),
                      AppText(
                        "Email Address",
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      SizedBox(height: 1.h),
                      AppFormField(
                        preficIconwidth: 10,
                        prefixIconheight: 10,
                        prefic_icons: SvgPicture.asset(AppIcons.emailIcon),
                        showPretixIcon: true,
                        title: "info@gmail.com",
                        textEditingController: emailC,
                        showBorder: true,
                        borderColor: Color(0xffDC9291),
                      ),
                      SizedBox(height: 3.h),
                      AppText(
                        "Password",
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                      SizedBox(height: 1.h),
                      AppFormField(
                        preficIconwidth: 10,
                        prefixIconheight: 10,
                        prefic_icons: SvgPicture.asset(AppIcons.lockIcon),
                        showPretixIcon: true,
                        title: "******",
                        textEditingController: passwordC,
                        showBorder: true,
                        borderColor: Color(0xffDC9291),
                        icon: Icons.visibility_outlined,

                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h,),
                AppButtonWidget(
                    onPressed: (){
                    },
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    width: 90.w,
                    height: 8.h,
                    buttonColor: Color(0xffC22522),
                    text: "Save Changes"),
                SizedBox(height: 1.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
