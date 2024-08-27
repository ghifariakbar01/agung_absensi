import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructures/image/infrastructures/image_repository.dart';
import '../shared/providers.dart';
import '../style/style.dart';
import 'image_absen.dart';

class LocationDetail extends ConsumerWidget {
  const LocationDetail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = ref.watch(imageUrlProvider);
    final displayImage = ref.watch(displayImageProvider);
    final isOfflineMode = ref.watch(absenOfflineModeProvider);

    final nearest =
        ref.watch(geofenceProvider.select((value) => value.nearestCoordinates));

    final nearestInMeter = nearest.remainingDistance.round().toString();

    bool inKm = nearestInMeter.length > 5 ? true : false;
    double distanceInKiloMeters = nearest.remainingDistance / 1000;
    final nearestInKiloMeter =
        double.parse((distanceInKiloMeters).toStringAsFixed(2)).toString();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Text(
                '${nearest.nama}',
                style: Themes.customColor(
                  15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Jarak Maksimum',
                      style: Themes.customColor(
                        12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' : ',
                      style: Themes.customColor(
                        12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (nearest.minDistance == 0) ...[
                      Text('....Loading....',
                          style: Themes.customColor(
                            12,
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                    if (nearest.minDistance != 0) ...[
                      Text(' ${nearest.minDistance.round()} m',
                          style: Themes.customColor(
                            12,
                            fontWeight: FontWeight.bold,
                          ))
                    ]
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Jarak',
                      style: Themes.customColor(
                        12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' : ',
                      style: Themes.customColor(
                        12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (nearest.remainingDistance == 0) ...[
                      Text('....Loading....',
                          style: Themes.customColor(
                            12,
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                    if (nearest.remainingDistance != 0) ...[
                      Text(
                          inKm
                              ? nearestInKiloMeter + ' km'
                              : nearestInMeter + ' m',
                          style: nearest.remainingDistance < nearest.minDistance
                              ? Themes.customColor(
                                  12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                )
                              : Themes.customColor(
                                  12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                )),
                    ]
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          displayImage == false && isOfflineMode
              ? Container()
              : ImageAbsen(imageUrl: Uri.parse(imageUrl)),
        ],
      ),
    );
  }
}
