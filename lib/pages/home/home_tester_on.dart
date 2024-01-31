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
    return Ink(
      width: 68,
      height: 68,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          showDialog(
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
                  onBackPressed: context.pop));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.location_off,
              color: Palette.primaryLighter,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Toggle Lokasi ( Off => On )',
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
