import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../../utils/string_utils.dart';

class BackgroundItemDetail extends StatelessWidget {
  const BackgroundItemDetail({
    Key? key,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.date,
  }) : super(key: key);

  final String date;
  final String alamat;
  final String latitude;
  final String longitude;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
                width: width,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Palette.primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)),
                child: // Lokasi Masuk
                    Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.pin_drop_rounded,
                          size: 25,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Lokasi',
                          style: Themes.customColor(FontWeight.bold, 10),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      alamat,
                      style: Themes.customColor(FontWeight.bold, 9),
                    )
                  ],
                )),
          ),
        ),

        // latitude longitude
        Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Column(
                children: [
                  // latitude
                  Flexible(
                    flex: 1,
                    child: Container(
                        width: width,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Palette.primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10)),
                        child: // Lokasi Masuk
                            Row(
                          children: [
                            Icon(
                              Icons.numbers,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Latitude',
                                  style:
                                      Themes.customColor(FontWeight.bold, 11),
                                ),
                                Text(
                                  latitude.length > 10
                                      ? '${latitude.substring(0, 10)}...'
                                      : latitude,
                                  maxLines: 1,
                                  style: Themes.customColor(FontWeight.bold, 8),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),

                  SizedBox(
                    height: 4,
                  ),

                  // longitude
                  Flexible(
                    flex: 1,
                    child: Container(
                        width: width,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Palette.primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10)),
                        child: // Longitude
                            Row(
                          children: [
                            Icon(
                              Icons.numbers,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Longitude',
                                  style:
                                      Themes.customColor(FontWeight.bold, 11),
                                ),
                                Text(
                                  longitude.length > 10
                                      ? '${longitude.substring(0, 10)}...'
                                      : longitude,
                                  maxLines: 1,
                                  style: Themes.customColor(FontWeight.bold, 8),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              ),
            )),

        // waktu
        Flexible(
          flex: 1,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                width: width,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Palette.primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)),
                child: // Longitude
                    Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Date',
                          style: Themes.customColor(FontWeight.bold, 11),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            StringUtils.formatTanggalJam(date),
                            maxLines: 5,
                            style: Themes.customColor(FontWeight.bold, 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
