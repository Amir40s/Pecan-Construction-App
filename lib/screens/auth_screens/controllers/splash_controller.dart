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
      // New user, navigate to role selection
      Get.offAllNamed(RoutesName.RoleSelectionScreen);
      return;
    }

    String uid = user.uid;

    // Check if user is Admin
    final adminDoc = await _firestore.collection("admin").doc(uid).get();
    if (adminDoc.exists) {
      Get.offAllNamed(RoutesName.BottomNavScreen); // Admin home
      return;
    }

    // Check if user is Employee
    final employeeDoc = await _firestore.collection("employees").doc(uid).get();
    if (employeeDoc.exists) {
      Get.offAllNamed(RoutesName.EmployeeBottomNavScreen); // Employee home
      return;
    }

    // fallback: If user exists but not in Admin/Employee, ask role
    Get.offAllNamed(RoutesName.RoleSelectionScreen);
  }
}