import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../shared/providers.dart';
import '../style/style.dart';
import 'image_absen.dart';

class LocationDetail extends ConsumerWidget {
  const LocationDetail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayImage = ref.watch(displayImageProvider);
    final isOfflineMode = ref.watch(absenOfflineModeProvider);
    final nearest =
        ref.watch(geofenceProvider.select((value) => value.nearestCoordinates));

    return Column(
      children: [
        //
        Row(
          children: [
            Text(
              'Kantor Terdekat',
              style: Themes.customColor(
                13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' : ',
              style: Themes.customColor(
                13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: Text(
                ' ${nearest.nama}',
                maxLines: 10,
                style: Themes.customColor(
                  13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Text(
              'Jarak Maksimum',
              style: Themes.customColor(
                13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' : ',
              style: Themes.customColor(
                13,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (nearest.minDistance == 0) ...[
              Text('....Loading....',
                  style: Themes.customColor(
                    13,
                    fontWeight: FontWeight.bold,
                  ))
            ],
            if (nearest.minDistance != 0) ...[
              Text(' ${nearest.minDistance.round()} m',
                  style: Themes.customColor(
                    13,
                    fontWeight: FontWeight.bold,
                  ))
            ]
          ],
        ),

        //
        Row(
          children: [
            Text(
              'Jarak',
              style: Themes.customColor(
                13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' : ',
              style: Themes.customColor(
                13,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (nearest.remainingDistance == 0) ...[
              Text('....Loading....',
                  style: Themes.customColor(
                    13,
                    fontWeight: FontWeight.bold,
                  ))
            ],
            if (nearest.remainingDistance != 0) ...[
              Text(' ${nearest.remainingDistance.round()} m',
                  style: nearest.remainingDistance < nearest.minDistance
                      ? Themes.customColor(14,
                          fontWeight: FontWeight.bold, color: Colors.green)
                      : Themes.customColor(14,
                          fontWeight: FontWeight.bold, color: Colors.red)),
            ]
          ],
        ),

        displayImage == false || isOfflineMode ? Container() : ImageAbsen(),
      ],
    );
  }
}
