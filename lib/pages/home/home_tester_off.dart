import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../style/style.dart';
import '../widgets/v_dialogs.dart';

class HomeTesterOff extends ConsumerWidget {
  const HomeTesterOff();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => VAlertDialog(
                label: 'TURN OFF LOCATION ?',
                labelDescription:
                    'Select if you want to turn off location and use without location.',
                pressedLabel: 'Yes',
                backPressedLabel: 'No',
                onPressed: () async {
                  await ref
                      .read(testerNotifierProvider.notifier)
                      .forceChangeToTester();

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
                  Icons.location_on_outlined,
                  color: Palette.primaryLighter,
                ))),
            SizedBox(
              height: 4,
            ),
            Text(
              'LOKASI',
              style: Themes.customColor(
                FontWeight.bold,
                9,
              ),
            )
          ],
        ),
      ),
    );
  }
}
