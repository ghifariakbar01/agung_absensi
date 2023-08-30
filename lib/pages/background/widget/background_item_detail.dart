import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../../utils/string_utils.dart';

class BackgroundItemDetail extends StatelessWidget {
  const BackgroundItemDetail(
      {Key? key,
      required this.alamat,
      required this.latitude,
      required this.longitude,
      required this.date})
      : super(key: key);

  final String alamat;
  final String latitude;
  final String longitude;
  final String date;

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
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Palette.primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)),
                child: // Lokasi Masuk
                    Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.pin_drop_rounded,
                          color: Colors.white,
                        ),
                        Text(
                          'Lokasi',
                          style: Themes.white(FontWeight.bold, 11),
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
                            alamat,
                            style: Themes.white(FontWeight.bold, 10),
                          ),
                        ),
                      ],
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
                              color: Colors.white,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Latitude',
                                  style: Themes.white(FontWeight.bold, 11),
                                ),
                                Text(
                                  latitude.length > 10
                                      ? '${latitude.substring(0, 10)}...'
                                      : latitude,
                                  style: Themes.white(FontWeight.bold, 10),
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
                              color: Colors.white,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Longitude',
                                  style: Themes.white(FontWeight.bold, 11),
                                ),
                                Text(
                                  longitude.length > 10
                                      ? '${longitude.substring(0, 10)}...'
                                      : longitude,
                                  style: Themes.white(FontWeight.bold, 10),
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
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Palette.primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)),
                child: // Longitude
                    Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.white,
                        ),
                        Text(
                          'Date',
                          style: Themes.white(FontWeight.bold, 11),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            StringUtils.formatTanggalJam(date),
                            maxLines: 5,
                            style: Themes.white(FontWeight.bold, 10),
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
