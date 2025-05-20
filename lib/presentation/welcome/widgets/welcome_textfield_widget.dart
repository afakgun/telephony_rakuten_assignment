import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/utils/textfield_utils.dart';

class WelcomeTextField extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final int maxLines;

  const WelcomeTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 6),
        TextFieldUtils.cardTextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          hintText: hint,
        ),
      ],
    );
  }
}
