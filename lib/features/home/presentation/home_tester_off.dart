import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/providers.dart';
import '../../../style/style.dart';
import '../../../widgets/v_dialogs.dart';

class HomeTesterOff extends ConsumerWidget {
  const HomeTesterOff();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Ink(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => VAlertDialog(
                  label: 'TURN OFF LOCATION ?',
                  labelDescription:
                      'Select if you want to turn off location mode.',
                  pressedLabel: 'Yes',
                  backPressedLabel: 'No',
                  onPressed: () async {
                    await ref
                        .read(testerNotifierProvider.notifier)
                        .forceChangeToTester();

                    context.pop();
                  },
                  onBackPressed: context.pop));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on,
              color: Palette.primaryLighter,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Toggle Lokasi (On => Off )',
              style: Themes.customColor(
                9,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
