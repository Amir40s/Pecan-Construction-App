import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';

class SignUpController extends GetxController {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  void SignUp() {
   final name  = nameC.text;
   final email = emailC.text;
   final password = passwordC.text;

   if(formKey.currentState!.validate()){
     if(name.isEmpty || email.isEmpty || password.isEmpty){
       Get.snackbar("alert", "all field are required");
       return;
     }
     else if(!GetUtils.isEmail(email)){
       Get.snackbar("alert", "email are bed formated");
       return ;
     }

     Get.toNamed(RoutesName.BottomNavScreen);
   }
  }
}