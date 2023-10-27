import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../style/style.dart';
import 'absen_button.dart';

class AbsenReset extends ConsumerWidget {
  const AbsenReset();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // LAT, LONG
    final nearest = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.remainingDistance));

    // JARAK MAKSIMUM
    final minDistance = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.minDistance));

    // RESET ABSEN
    // final buttonIn = ref.watch(buttonInProvider);
    // final buttonOut = ref.watch(buttonOutProvider);
    final buttonResetVisibility = ref.watch(buttonResetVisibilityProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: nearest < minDistance && nearest != 0
                ? Colors.transparent
                : Palette.greyDisabled),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Absen Ulang',
                style: Themes.customColor(
                    FontWeight.bold,
                    14,
                    nearest < minDistance && nearest != 0
                        ? Colors.black
                        : Palette.grey),
              ),
              SizedBox(
                width: 8,
              ),
              IgnorePointer(
                ignoring: nearest > minDistance || nearest == 0,
                child: Switch(
                  value: buttonResetVisibility,
                  onChanged: (value) => ref
                      .read(buttonResetVisibilityProvider.notifier)
                      .state = value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
