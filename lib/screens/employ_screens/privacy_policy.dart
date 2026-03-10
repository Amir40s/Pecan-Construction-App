import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black),
          onPressed: (){
            Get.back();
          },
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: 12),

            Text(
              "This application is designed to help administrators and employees manage construction sites, schedules, and documents efficiently. Your privacy is important to us and we are committed to protecting your personal data.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 20),

            Text(
              "Information We Collect",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 6),

            Text(
              "We may collect basic user information such as name, email address, and assigned construction site information in order to provide proper access and functionality within the application.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 20),

            Text(
              "How We Use Information",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 6),

            Text(
              "The collected information is used only for managing construction sites, assigning employees, sending notifications, and improving the overall experience of the application.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 20),

            Text(
              "Data Security",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 6),

            Text(
              "We implement appropriate security measures to protect your data from unauthorized access, disclosure, or alteration.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 20),

            Text(
              "Contact",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 6),

            Text(
              "If you have any questions regarding this Privacy Policy, please contact the administrator of the application.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}