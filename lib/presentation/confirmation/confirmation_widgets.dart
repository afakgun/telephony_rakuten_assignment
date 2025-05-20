import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/utils/textfield_utils.dart';

class ConfirmationCodeInput extends StatelessWidget {
  final void Function(String) onChanged;
  const ConfirmationCodeInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TextField(
        maxLength: 6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 8,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
          hintText: '------',
        ),
        onChanged: onChanged,
      ),
    );
  }
}
