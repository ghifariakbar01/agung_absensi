import 'package:face_net_authentication/application/providers/geofence_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';

class LocationDetail extends ConsumerWidget {
  const LocationDetail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearest = ref.watch(geofenceProvider
        .select((value) => value.geofenceList[value.nearestIndex]));

    return Column(
      children: [
        //
        Row(
          children: [
            Text(
              'Kantor Terdekat',
              style: Themes.black(FontWeight.bold, 14),
            ),
            Text(
              ' : ',
              style: Themes.black(FontWeight.bold, 14),
            ),
            Text(
              ' ${nearest.data}',
              style: Themes.black(FontWeight.bold, 14),
            ),
          ],
        ),

        //
        Row(
          children: [
            Text(
              'Jarak',
              style: Themes.black(FontWeight.bold, 14),
            ),
            Text(
              ' : ',
              style: Themes.black(FontWeight.bold, 14),
            ),
            if (nearest.remainingDistance != null) ...[
              Text(' ${nearest.remainingDistance!.round()} m',
                  style: nearest.remainingDistance! < 100
                      ? Themes.customColor(FontWeight.bold, 14, Colors.green)
                      : Themes.customColor(FontWeight.bold, 14, Colors.red)),
            ]
          ],
        ),
      ],
    );
  }
}
