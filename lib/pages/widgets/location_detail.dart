import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../style/style.dart';

class LocationDetail extends ConsumerWidget {
  const LocationDetail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearest =
        ref.watch(geofenceProvider.select((value) => value.nearestCoordinates));

    return Column(
      children: [
        //
        Row(
          children: [
            Text(
              'Kantor Terdekat',
              style: Themes.customColor(FontWeight.bold, 13, Colors.black),
            ),
            Text(
              ' : ',
              style: Themes.customColor(FontWeight.bold, 13, Colors.black),
            ),
            Text(
              ' ${nearest.nama}',
              style: Themes.customColor(FontWeight.bold, 13, Colors.black),
            ),
          ],
        ),

        //
        Row(
          children: [
            Text(
              'Jarak',
              style: Themes.customColor(FontWeight.bold, 13, Colors.black),
            ),
            Text(
              ' : ',
              style: Themes.customColor(FontWeight.bold, 13, Colors.black),
            ),
            if (nearest.remainingDistance != null) ...[
              Text(' ${nearest.remainingDistance.round()} m',
                  style: nearest.remainingDistance < 100
                      ? Themes.customColor(FontWeight.bold, 14, Colors.green)
                      : Themes.customColor(FontWeight.bold, 14, Colors.red)),
            ]
          ],
        ),
      ],
    );
  }
}
