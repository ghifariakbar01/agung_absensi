import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/application/route_names.dart';

class CopyrightAgung extends StatelessWidget {
  const CopyrightAgung({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () => context.pushNamed(RouteNames.copyrightRoute),
        child: Text(
          'FILL IN AND GENERAL EMPLOYEE INFORMATION\n © M.I.S AGUNG LOGISTICS 2023',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: Themes.customColor(
            8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
