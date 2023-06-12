import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../style/style.dart';
import '../../../../core/application/routes/route_names.dart';

class AbsenInButton extends ConsumerWidget {
  const AbsenInButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => context.pushNamed(RouteNames.cameraNameRoute),
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            'ABSEN IN',
            style: Themes.blueSpaced(
              FontWeight.bold,
              16,
            ),
          ),
        ),
      ),
    );
  }
}
