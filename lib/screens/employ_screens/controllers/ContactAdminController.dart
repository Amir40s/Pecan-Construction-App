import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactAdminController extends GetxController {

  final String adminEmail;
  final String adminPhone;

  ContactAdminController({
    required this.adminEmail,
    required this.adminPhone,
  });

  final messageController = TextEditingController();

  final isSending = false.obs;

  Future<void> sendMessage() async {

    final msg = messageController.text.trim();

    if (msg.isEmpty) {
      Get.snackbar("Message", "Please write a message first");
      return;
    }

    try {

      isSending.value = true;

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: adminEmail,
        query: Uri.encodeFull(
          'subject=Contact Admin&body=$msg',
        ),
      );

      await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

    } catch (e) {
      Get.snackbar("Error", "Could not open email app");
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}