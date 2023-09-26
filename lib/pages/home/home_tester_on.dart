import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../style/style.dart';
import '../widgets/v_dialogs.dart';

class HomeTesterOn extends ConsumerWidget {
  const HomeTesterOn();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => VAlertDialog(
                label: 'TURN ON LOCATION ?',
                labelDescription:
                    'Select if you want to turn on and use location mode.',
                pressedLabel: 'Yes',
                backPressedLabel: 'No',
                onPressed: () async {
                  await ref
                      .read(testerNotifierProvider.notifier)
                      .forceChangeToRegular();

                  context.pop();
                },
                onBackPressed: () => context.pop()));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Palette.primaryLighter,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    child: Icon(
                  Icons.location_off,
                  color: Palette.primaryLighter,
                ))),
            Text(
              'LOKASI',
              style: Themes.customColor(FontWeight.bold, 9, Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
