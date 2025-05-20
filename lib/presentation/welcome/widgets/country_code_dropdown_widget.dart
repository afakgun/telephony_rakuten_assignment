import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/welcome/model/country_code_model.dart';
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
    return DropdownUtils.cardDropdown<String>(
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
    );
  }
}
