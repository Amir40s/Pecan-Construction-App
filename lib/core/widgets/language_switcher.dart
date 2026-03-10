import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LanguageSwitcher extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onChanged;

  const LanguageSwitcher({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: BoxBorder.all(color: Colors.grey.shade200)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item("English"),
          Container(
            height: 4.h,
            width: 1,
            color: Colors.grey.shade300,
          ),
          _item("German"),
        ],
      ),
    );
  }

  Widget _item(String language) {
    final bool isSelected = language == selectedLanguage;

    return GestureDetector(
      onTap: () => onChanged(language),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
             Icon(Icons.language, size: 16,color: isSelected ? Colors.red : Colors.black,),
            const SizedBox(width: 6),

            Text(
              language,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
