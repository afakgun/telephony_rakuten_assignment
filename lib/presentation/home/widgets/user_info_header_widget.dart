import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/utils/textstyle_utils.dart';

class UserInfoHeader extends StatelessWidget {
  final String? name;
  final String? phone;
  final String? countryCode;
  const UserInfoHeader({
    super.key,
    required this.name,
    required this.phone,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/svg/flags/$countryCode.svg',
          width: 36,
          height: 36,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name ?? 'user_not_found'.tr, style: TextStyleUtils.blackColorBoldText(16)),
            Text(phone ?? 'phone_not_found'.tr, style: TextStyleUtils.blackColorRegularText(14)),
          ],
        ),
      ],
    );
  }
}
