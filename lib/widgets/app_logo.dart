import 'package:flutter/cupertino.dart';

import '../../../constants/assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 139, child: Image.asset(Assets.iconLogoFinger));
  }
}
