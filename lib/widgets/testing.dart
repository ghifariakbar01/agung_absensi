import 'package:flutter/material.dart';

import '../../style/style.dart';

class Testing extends StatelessWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: '-- APK TESTING --',
            style: Themes.customColor(14,
                fontWeight: FontWeight.bold, color: Palette.red),
          ),
          TextSpan(
            text:
                '  Uninstall dan logout jika anda tidak terdaftar dalam fase Testing.',
            style: Themes.customColor(
              14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
