import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';

class Splash_Controller extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> checkLogin() async {

    User? user = _auth.currentUser;

    if (user == null) {
      Get.offAllNamed(RoutesName.splash);
      return;
    }

    String uid = user.uid;

    /// Check Admin
    final adminDoc =
    await _firestore.collection("admins").doc(uid).get();

    if (adminDoc.exists) {
      Get.offAll(RoutesName.BottomNavScreen);
      return;
    }

    /// Check Employee
    final employeeDoc =
    await _firestore.collection("employees").doc(uid).get();

    if (employeeDoc.exists) {
      Get.offAllNamed(RoutesName.EmployeeBottomNavScreen);
      return;
    }

    /// fallback
    Get.offAllNamed(RoutesName.splash);
  }
}