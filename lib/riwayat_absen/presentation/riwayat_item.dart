import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../absen/application/absen_enum.dart';
import '../../style/style.dart';

class RiwayatItem extends ConsumerWidget {
  const RiwayatItem({
    required this.jam,
    required this.alamat,
    required this.jenisAbsen,
  });

  final JenisAbsen jenisAbsen;
  final String jam;
  final String alamat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final coancenate = jenisAbsen == JenisAbsen.absenIn ? 'In' : 'Out';

    return Column(
      children: [
        Flexible(
          flex: 0,
          child: Container(
            width: width,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(9)),
            child: Column(
              children: [
                // Jam Masuk
                Row(
                  children: [
                    Icon(
                        //
                        Icons.alarm,
                        size: 15,
                        color: Theme.of(context).unselectedWidgetColor),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jam $coancenate',
                          style: Themes.customColor(10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        Text(
                          jam,
                          style: Themes.customColor(9,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        if (alamat.isNotEmpty && alamat != 'NULL (APPLE REVIEW)') ...[
          Flexible(
            flex: 1,
            child: Container(
              width: width,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(9)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 0,
                    child: Icon(
                        //
                        Icons.pin_drop_rounded,
                        size: 15,
                        color: Theme.of(context).unselectedWidgetColor),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            'Lokasi $coancenate',
                            style: Themes.customColor(10,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).unselectedWidgetColor),
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            alamat,
                            style: Themes.customColor(9,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).unselectedWidgetColor),
                            minFontSize: 5,
                            maxFontSize: 9,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
