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
                    color: Palette.containerBackgroundColor.withOpacity(0.1),
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
                          size: 15,
                          color: Palette.primaryColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Lokasi',
                          style: Themes.customColor(
                            10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      alamat,
                      style: Themes.customColor(
                        9,
                        fontWeight: FontWeight.bold,
                      ),
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
                            color: Palette.containerBackgroundColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: // Lokasi Masuk
                            Row(
                          children: [
                            Icon(
                              Icons.numbers,
                              size: 20,
                              color: Palette.primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Latitude',
                                  style: Themes.customColor(
                                    10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  latitude.length > 10
                                      ? '${latitude.substring(0, 10)}...'
                                      : latitude,
                                  maxLines: 1,
                                  style: Themes.customColor(
                                    8,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                            color: Palette.containerBackgroundColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: // Longitude
                            Row(
                          children: [
                            Icon(
                              Icons.numbers,
                              size: 15,
                              color: Palette.primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Longitude',
                                  style: Themes.customColor(
                                    10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  longitude.length > 10
                                      ? '${longitude.substring(0, 10)}...'
                                      : longitude,
                                  maxLines: 1,
                                  style: Themes.customColor(8,
                                      fontWeight: FontWeight.bold),
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
                    color: Palette.containerBackgroundColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: // Longitude
                    Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 15,
                          color: Palette.primaryColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Date',
                          style: Themes.customColor(10,
                              fontWeight: FontWeight.bold),
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
                            maxLines: 3,
                            style: Themes.customColor(10,
                                fontWeight: FontWeight.bold),
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
