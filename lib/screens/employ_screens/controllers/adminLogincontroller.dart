import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';

class AdminLoginController extends GetxController {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final profileNameC = TextEditingController();
  final profileEmailC = TextEditingController();

  RxBool isLoggingIn = false.obs;
  RxBool isProfileLoading = false.obs;
  RxBool isSavingProfile = false.obs;
  RxBool hasProfileChanges = false.obs;

  final formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final GetStorage _box = GetStorage();
  RxBool isPasswordVisible = true.obs;
  static const String _adminSessionKey = 'admin_session';

  RxString adminDocId = ''.obs;
  RxString adminName = ''.obs;
  RxString adminEmail = ''.obs;
  RxString adminProfileImage = ''.obs;

  Rx<File?> selectedProfileImage = Rx<File?>(null);

  String _initialName = '';
  String _initialImageUrl = '';

  bool get isAdminLoggedIn => adminDocId.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();

    _loadAdminFromStorage();

    profileNameC.addListener(() {
      adminName.value = profileNameC.text.trim();
      _checkProfileChanges();
      update();
    });
  }

  void togglePassword () {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void _saveAdminToStorage() {
    _box.write(_adminSessionKey, {
      "adminDocId": adminDocId.value,
      "adminName": adminName.value,
      "adminEmail": adminEmail.value,
      "adminProfileImage": adminProfileImage.value,
    });
  }

  void _loadAdminFromStorage() {
    final data = _box.read(_adminSessionKey);

    if (data is Map) {
      adminDocId.value = (data["adminDocId"] ?? "").toString();
      adminName.value = (data["adminName"] ?? "").toString();
      adminEmail.value = (data["adminEmail"] ?? "").toString();
      adminProfileImage.value = (data["adminProfileImage"] ?? "").toString();

      profileNameC.text = adminName.value;
      profileEmailC.text = adminEmail.value;

      _initialName = adminName.value;
      _initialImageUrl = adminProfileImage.value;
    }
  }

  void _clearAdminFromStorage() {
    _box.remove(_adminSessionKey);
  }

  Future<void> loginAdmin() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and password are required",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoggingIn.value = true;

      final querySnapshot = await _firestore
          .collection("admin")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .limit(10)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();

        adminDocId.value = doc.id;
        adminName.value = (data["name"] ?? "").toString();
        adminEmail.value = (data["email"] ?? "").toString();
        adminProfileImage.value = (data["profileImage"] ?? "").toString();

        profileNameC.text = adminName.value;
        profileEmailC.text = adminEmail.value;

        _initialName = adminName.value;
        _initialImageUrl = adminProfileImage.value;
        hasProfileChanges.value = false;
        selectedProfileImage.value = null;

        _saveAdminToStorage();
        final box = GetStorage();
        box.write('logged_in_admin_email', profileEmailC.text);
        update();

        Get.snackbar(
          "Success",
          "Login Successful",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(RoutesName.BottomNavScreen);
      } else {
        Get.snackbar(
          "Error",
          "Invalid email or password",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoggingIn.value = false;
    }
  }

  Future<void> fetchAdminProfile() async {
    try {
      if (adminDocId.value.isEmpty) {
        Get.snackbar("Error", "Admin not found. Please login again.");
        return;
      }

      isProfileLoading.value = true;

      final doc = await _firestore.collection("admin").doc(adminDocId.value).get();

      if (!doc.exists) {
        Get.snackbar("Error", "Admin profile not found");
        return;
      }

      final data = doc.data() ?? {};

      adminName.value = (data["name"] ?? "").toString();
      adminEmail.value = (data["email"] ?? "").toString();
      adminProfileImage.value = (data["profileImage"] ?? "").toString();

      profileNameC.text = adminName.value;
      profileEmailC.text = adminEmail.value;

      _initialName = adminName.value;
      _initialImageUrl = adminProfileImage.value;
      selectedProfileImage.value = null;
      hasProfileChanges.value = false;

      _saveAdminToStorage();
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch profile: $e");
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (file != null) {
        selectedProfileImage.value = File(file.path);
        _checkProfileChanges();
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Image pick failed: $e");
    }
  }

  void _checkProfileChanges() {
    final isNameChanged = profileNameC.text.trim() != _initialName.trim();
    final isImageChanged = selectedProfileImage.value != null;

    hasProfileChanges.value = isNameChanged || isImageChanged;
  }

  Future<String?> _uploadProfileImage(File file) async {
    try {
      if (adminDocId.value.isEmpty) return null;

      final ref = _storage.ref().child("admin_profiles/${adminDocId.value}.jpg");
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Image upload failed: $e");
      return null;
    }
  }

  Future<void> saveProfileChanges() async {
    if (!hasProfileChanges.value) {
      Get.snackbar("Info", "No changes found");
      return;
    }

    if (adminDocId.value.isEmpty) {
      Get.snackbar("Error", "Admin id missing. Please login again.");
      return;
    }

    try {
      isSavingProfile.value = true;

      String imageUrl = adminProfileImage.value;

      if (selectedProfileImage.value != null) {
        final uploadedImageUrl =
        await _uploadProfileImage(selectedProfileImage.value!);

        if (uploadedImageUrl != null && uploadedImageUrl.isNotEmpty) {
          imageUrl = uploadedImageUrl;
        }
      }

      final updatedName = profileNameC.text.trim();

      final updatedData = {
        "name": updatedName,
        "email": profileEmailC.text.trim(),
        "profileImage": imageUrl,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection("admin")
          .doc(adminDocId.value)
          .update(updatedData);

      /// local reactive values update
      adminName.value = updatedName;
      adminEmail.value = profileEmailC.text.trim();
      adminProfileImage.value = imageUrl;

      /// controllers sync
      profileNameC.text = updatedName;
      profileEmailC.text = adminEmail.value;

      /// new initial values
      _initialName = updatedName;
      _initialImageUrl = imageUrl;

      /// clear temporary picked image
      selectedProfileImage.value = null;
      hasProfileChanges.value = false;

      /// GetStorage use kar rahe ho to ye bhi call karo
      _saveAdminToStorage();

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e");
    } finally {
      isSavingProfile.value = false;
    }
  }
  void logoutAdmin() {
    final box = GetStorage();
    box.remove('logged_in_admin_email');
    Get.offAllNamed(RoutesName.RoleSelectionScreen);
  }

  // Future<void> logoutAdmin() async {
  //   final box = GetStorage();
  //   box.remove('logged_in_admin_email');
  //   Get.offAllNamed(RoutesName.RoleSelectionScreen);
  //   adminDocId.value = '';
  //   adminName.value = '';
  //   adminEmail.value = '';
  //   adminProfileImage.value = '';
  //
  //   emailC.clear();
  //   passwordC.clear();
  //   profileNameC.clear();
  //   profileEmailC.clear();
  //
  //   selectedProfileImage.value = null;
  //   hasProfileChanges.value = false;
  //   _initialName = '';
  //   _initialImageUrl = '';
  //
  //   _clearAdminFromStorage();
  //   update();
  //
  //   Get.offAllNamed(RoutesName.splash);
  // }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    profileNameC.dispose();
    profileEmailC.dispose();
    super.onClose();
  }
}