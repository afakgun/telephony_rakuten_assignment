import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/utils/textfield_utils.dart';
import 'package:telephony_rakuten_assignment/utils/dropdown_utils.dart';

class CountryCodeDropdown extends StatelessWidget {
  final String value;
  final List<CountryCodeItem> items;
  final ValueChanged<String?> onChanged;

  const CountryCodeDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DropdownUtils.cardDropdown<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item.code,
            child: Row(
              children: [
                SvgPicture.asset(
                  item.flagAsset,
                  width: 28,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8),
                Text(item.code, style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CountryCodeItem {
  final String code;
  final String flagAsset;

  CountryCodeItem({required this.code, required this.flagAsset});
}

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
