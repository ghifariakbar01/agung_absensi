import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../style/style.dart';
import 'image_absen.dart';

class LocationDetail extends ConsumerWidget {
  const LocationDetail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayImage = ref.watch(displayImageProvider);
    final isOffline = ref.watch(absenOfflineModeProvider);
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
                FontWeight.bold,
                13,
              ),
            ),
            Text(
              ' : ',
              style: Themes.customColor(
                FontWeight.bold,
                13,
              ),
            ),
            Flexible(
              child: Text(
                ' ${nearest.nama}',
                maxLines: 10,
                style: Themes.customColor(
                  FontWeight.bold,
                  13,
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
                FontWeight.bold,
                13,
              ),
            ),
            Text(
              ' : ',
              style: Themes.customColor(
                FontWeight.bold,
                13,
              ),
            ),
            if (nearest.minDistance == 0) ...[
              Text('....Loading....',
                  style: Themes.customColor(
                    FontWeight.bold,
                    13,
                  ))
            ],
            if (nearest.minDistance != 0) ...[
              Text(' ${nearest.minDistance.round()} m',
                  style: Themes.customColor(
                    FontWeight.bold,
                    13,
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
                FontWeight.bold,
                13,
              ),
            ),
            Text(
              ' : ',
              style: Themes.customColor(
                FontWeight.bold,
                13,
              ),
            ),
            if (nearest.remainingDistance == 0) ...[
              Text('....Loading....',
                  style: Themes.customColor(
                    FontWeight.bold,
                    13,
                  ))
            ],
            if (nearest.remainingDistance != 0) ...[
              Text(' ${nearest.remainingDistance.round()} m',
                  style: nearest.remainingDistance < nearest.minDistance
                      ? Themes.customColor(FontWeight.bold, 14,
                          color: Colors.green)
                      : Themes.customColor(FontWeight.bold, 14,
                          color: Colors.red)),
            ]
          ],
        ),

        displayImage == false || isOffline ? Container() : ImageAbsen(),
      ],
    );
  }
}
