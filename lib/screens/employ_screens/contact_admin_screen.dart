import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pecan_construction/screens/employ_screens/controllers/adminLogincontroller.dart';
import 'package:sizer/sizer.dart';
import '../../core/constant/app_images.dart';
import 'controllers/ContactAdminController.dart';

class ContactAdminScreen extends StatefulWidget {
  const ContactAdminScreen({
    super.key,
    this.adminEmail = "info@gmail.com",
    this.adminPhone = "+92 300 1234567",
  });
  final String adminEmail;
  final String adminPhone;

  @override
  State<ContactAdminScreen> createState() => _ContactAdminScreenState();
}

class _ContactAdminScreenState extends State<ContactAdminScreen> {
  final TextEditingController messageController = TextEditingController();
  final adminC = Get.put(AdminLoginController());
  bool isSending = false;
  late final controller = Get.put(
    ContactAdminController(
      adminEmail: widget.adminEmail,
      adminPhone: widget.adminPhone,
    ),
  );

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> _openEmail() async {
    final msg = messageController.text.trim();

    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write a message first.")),
      );
      return;
    }
    setState(() => isSending = true);

    // mailto with prefilled TO + subject + body
    final subject = Uri.encodeComponent("Contact Admin");
    final body = Uri.encodeComponent(msg);

    final uri = Uri.parse("mailto:${widget.adminEmail}?subject=$subject&body=$body");

    try {
      // final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      // if (!ok && mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Could not open email app.")),
      //   );
      // }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open email app.")),
      );
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF7F7F7);
    final red = const Color(0xFFB01818);
    final borderRed = const Color(0xFFE58E8E);

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Top bar with circular back + title
                Row(
                  children: [
                    _CircleIconButton(
                      icon: Icons.arrow_back_ios,
                      onTap: () => Navigator.pop(context),
                    ),
                    Gap(20.w),
                    const Text(
                      "Contact Admin",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    // right placeholder to keep title centered
                    const SizedBox(width: 44, height: 44),
                  ],
                ),

                const SizedBox(height: 16),

                // Avatar + role
                Column(
                  children: [
                    Obx(() {
                      if (adminC.selectedProfileImage.value != null) {
                        return CircleAvatar(
                          radius: 43,
                          backgroundImage:
                          FileImage(adminC.selectedProfileImage.value!),
                        );
                      }

                      return CircleAvatar(
                        radius: 43,
                        backgroundImage: adminC.adminProfileImage.value.isNotEmpty
                            ? NetworkImage(adminC.adminProfileImage.value)
                            :  AssetImage(AppImages.profileImage)
                        as ImageProvider,
                      );
                    }),

                    const SizedBox(height: 10),

                    Obx(() => Text(
                      adminC.adminName.value.isEmpty
                          ? "Admin"
                          : adminC.adminName.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB01818),
                      ),
                    )),
                  ],
                ),

                const SizedBox(height: 18),

                // Email (readOnly)
                _Label("Admin Email"),
                const SizedBox(height: 6),
                _InputBox(
                  borderColor: borderRed,
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined, size: 18, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.adminEmail,
                          style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Phone (readOnly)
                _Label("Admin Number"),
                const SizedBox(height: 6),
                _InputBox(
                  borderColor: borderRed,
                  child: Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 18, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.adminPhone,
                          style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Message (editable)
                _Label("Message"),
                const SizedBox(height: 6),
                _InputBox(
                  borderColor: borderRed,
                  child: TextField(
                    controller:  controller.messageController,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 13.5),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Write your message to admin...",
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
            Gap(12.h),

                // Send button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: controller.isSending.value
                        ? null
                        : controller.sendMessage,
                    child: controller.isSending.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Send",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.black87),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.child,
    required this.borderColor,
  });

  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        padding: EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black87,
          border: Border.all(color: Colors.black.withOpacity(0.08)),
        ),
        child: Icon(icon, color: Colors.white,size: 20,),
      ),
    );
  }
}
