import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/models/employeeModel.dart';
import 'package:pecan_construction/core/repo/employee_repository.dart';
import 'package:pecan_construction/core/widgets/failure.dart';

import '../../../core/services/notification_services.dart';

class SignUpController extends GetxController {
  final EmployeeRepository repository = EmployeeRepository();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLogginOut = false.obs;
  final formKey = GlobalKey<FormState>();

  final picker = ImagePicker();

  // UI state
  final isUploading = false.obs;
  final isLogging= false.obs;
  final avatarUrl = "".obs;
  final originalName = "".obs;
  final currentName = "".obs; // Added to make hasChanges reactive to typing
  // picked image preview
  final Rxn<Uint8List> pickedBytes = Rxn<Uint8List>();
  File? pickedFile; // mobile

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes to make hasChanges reactive instantly
    nameC.addListener(() {
      currentName.value = nameC.text;
    });
  }


  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  // (optional) profile data observables
  final employeeName = "".obs;

  bool get hasChanges {
    final nameChanged = currentName.value.trim() != originalName.value;
    final imageChanged = pickedBytes.value != null;

    return nameChanged || imageChanged;
  }

  Future<void> SignUpEmployee() async {
    if (formKey.currentState!.validate()) {
      final employee = EmployeeModel(
        id: "",
        name: nameC.text,
        email: emailC.text,
        password: passwordC.text,
        assignedSites: [],
        avatarUrl: "",
      );

      isLoading.value = true;

      final result = await repository.registeredEmployee(employee);

      result.match(
            (f) {
          isLoading.value = false;
          Get.snackbar("error", f.message);
        },
            (savedEmployee) async  {
          isLoading.value = false;
          Get.snackbar("Success", "Employee Created successfully");
          await NotificationService().setup();
          Get.offNamed(RoutesName.EmployeeBottomNavScreen);
        },
      );
    }
  }

  ////pick profile image
  Future<void> pickProfileImage() async {
    try {
      XFile? x = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (x == null) return;

      if (kIsWeb) {
        pickedBytes.value = await x.readAsBytes();
        pickedFile = null; // fix: "=" hona chahiye, "==" nahi
      } else {
        pickedFile = File(x.path);
        pickedBytes.value = await x.readAsBytes(); // preview ke liye
      }
    } catch (e) {
      Get.snackbar("error", e.toString());
    }
  }

  Future<void> uploadPickedProfileImage({required String uid}) async {
    if (kIsWeb && pickedBytes.value == null) {
      Get.snackbar("Error", "Please select an image first");
      return;
    }
    if (!kIsWeb && pickedFile == null) {
      Get.snackbar("Error", "Please select an image first");
      return;
    }

    isUploading.value = true;

    final Either<Failure, String> res = await repository.uploadProfileImage(
      uid: uid,
      file: pickedFile,
      bytes: pickedBytes.value,
    );

    res.fold(
          (f) => Get.snackbar("Upload Failed", f.message),
          (url) {
        avatarUrl.value = url;
        Get.snackbar("Success", "Profile image updated");
      },
    );

    isUploading.value = false;
  }

  //  NEW: Update profile (name + avatarUrl)
  // - Pehle image upload (agar selected ho)
  // - Phir Firestore me Employees/{uid} update: name + avatarUrl
  Future<void> updateEmployeeProfile({required String uid}) async {
    final newName = nameC.text.trim();
    if (newName.isEmpty) {
      Get.snackbar("Error", "Name is required");
      return;
    }

    isLoading.value = true;

    String? newAvatarUrl;

    // 1) upload image if selected
    final hasNewImage = (kIsWeb && pickedBytes.value != null) ||
        (!kIsWeb && pickedFile != null);

    if (hasNewImage) {
      isUploading.value = true;

      final uploadRes = await repository.uploadProfileImage(
        uid: uid,
        file: pickedFile,
        bytes: pickedBytes.value,
      );

      isUploading.value = false;

      final uploadEither = uploadRes;
      final failed = uploadEither.fold((l) => l, (_) => null);

      if (failed != null) {
        isLoading.value = false;
        Get.snackbar("Upload Failed", failed.message);
        return;
      }

      newAvatarUrl = uploadEither.fold((_) => null, (r) => r);
    }

    // 2) update firestore
    final updateRes = await repository.updateEmployeeProfile(
      uid: uid,
      name: newName,
      avatarUrl: newAvatarUrl, // null ho to repository skip kare
    );

    updateRes.fold(
          (f) => Get.snackbar("Update Failed", f.message),
          (_) {
        employeeName.value = newName;
        if (newAvatarUrl != null) avatarUrl.value = newAvatarUrl;
        Get.snackbar("Success", "Profile updated");
      },
    );

    isLoading.value = false;
  }

  //  NEW: Fetch profile for profile screen
  Future<void> loadEmployeeProfile({required String uid}) async {
    isLoading.value = true;

    final res = await repository.getEmployeeById(uid);

    res.fold(
          (f) => Get.snackbar("Error", f.message),
          (emp) {
        employeeName.value = emp.name;
        avatarUrl.value = emp.avatarUrl!;

        // profile screen fields prefill
        nameC.text = emp.name;
        emailC.text = emp.email;

        //  original value store (important)
        originalName.value = emp.name;
        currentName.value = emp.name; // Reset currentName to match original Name
      },
    );

    isLoading.value = false;
  }

  Future<void> LogoutEmployee() async {
    try{
      isLogginOut.value = true;
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(RoutesName.splash);
    }
    catch (e){
      isLogginOut.value = true;
      Get.snackbar("error", e.toString());

    }
    finally{
      isLogginOut.value = true;
    }
  }
  Future<void> deleteAccount() async {
    log("deleting account");
    isLogging.value = true;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String uid = user.uid;

      await firestore.collection("employees").doc(uid).delete();
      await user.delete();

      Get.offAllNamed(RoutesName.splash);
    } catch (e) {
      log("Delete account error: $e");

      Get.snackbar(
        "Error",
        "Failed to delete account",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLogging.value = false;
    }
  }
}