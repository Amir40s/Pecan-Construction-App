import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:pecan_construction/core/widgets/header_widget.dart';
import '../../core/widgets/app_text_field.dart';
import 'admin_controller/assign_employee_controller.dart';

class AssignEmployeeScreen extends GetView<AssignEmployeeController> {
  AssignEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(title: "Assign Employee", showBack: true),
                SizedBox(height: 2.h),

                _label("Employee Name"),
                AppFormField(
                  title: "Name of Employee",
                  textEditingController: controller.nameC,
                  validator: controller.nameValidator,
                  textInputType: TextInputType.name,
                  showBorder: true,
                ),

                SizedBox(height: 1.8.h),

                _label("Employee Email"),
                AppFormField(
                  title: "Email",
                  textEditingController: controller.emailC,
                  validator: controller.emailValidator,
                  textInputType: TextInputType.emailAddress,
                  showBorder: true,
                ),

                SizedBox(height: 1.8.h),

                _label("Job Role"),
                Obx(() => _JobRoleDropdown(
                  value: controller.selectedJobRole.value,
                  items: controller.jobRoles,
                  onChanged: controller.changeRole,
                )),

                SizedBox(height: 3.h),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xffC22522),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.onNext,
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _JobRoleDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _JobRoleDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items
              .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(
              e,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
