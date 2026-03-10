import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          "Terms & Conditions",
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
              "Terms & Conditions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: 12),

            Text(
              "By using this application, you agree to comply with and be bound by the following terms and conditions.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 20),

            Text(
              "Use of Application",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 6),

            Text(
              "This application is intended for construction site management. Employees can view assigned sites, download files, and receive notifications.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 20),

            Text(
              "User Responsibilities",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 6),

            Text(
              "Users must ensure that the information accessed through the application is used responsibly and only for official project purposes.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 20),

            Text(
              "Intellectual Property",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 6),

            Text(
              "All content, files, and data within the application remain the property of the organization managing the construction projects.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 20),

            Text(
              "Changes to Terms",
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 6),

            Text(
              "The administrator may update these terms from time to time. Continued use of the application indicates acceptance of the updated terms.",
              style: TextStyle(fontSize: 14,height: 1.6),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}