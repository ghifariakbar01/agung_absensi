import 'dart:developer';

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
            Flexible(
              child: Text(
                ' ${nearest.nama}',
                maxLines: 10,
                style: Themes.customColor(FontWeight.bold, 13, Colors.black),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Text(
              'Jarak Maksimum',
              style: Themes.customColor(FontWeight.bold, 13, Colors.black),
            ),
            Text(
              ' : ',
              style: Themes.customColor(FontWeight.bold, 13, Colors.black),
            ),
            if (nearest.minDistance == 0) ...[
              Text('....Loading....',
                  style: Themes.customColor(
                      FontWeight.bold, 13, Palette.primaryColor))
            ],
            if (nearest.minDistance != 0) ...[
              Text(' ${nearest.minDistance.round()} m',
                  style: Themes.customColor(
                      FontWeight.bold, 13, Palette.primaryColor))
            ]
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
            if (nearest.remainingDistance == 0) ...[
              Text('....Loading....',
                  style: Themes.customColor(
                      FontWeight.bold, 13, Palette.primaryColor))
            ],
            if (nearest.remainingDistance != 0) ...[
              Text(' ${nearest.remainingDistance.round()} m',
                  style: nearest.remainingDistance < nearest.minDistance
                      ? Themes.customColor(FontWeight.bold, 14, Colors.green)
                      : Themes.customColor(FontWeight.bold, 14, Colors.red)),
            ]
          ],
        ),
      ],
    );
  }
}
