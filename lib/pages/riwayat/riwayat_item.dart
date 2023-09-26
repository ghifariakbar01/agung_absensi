import 'package:auto_size_text/auto_size_text.dart';
import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                // Jam Masuk
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      color: Palette.primaryLighter,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jam $coancenate',
                          style: Themes.customColor(
                              FontWeight.bold, 12, Palette.primaryLighter),
                        ),
                        Text(
                          jam,
                          style: Themes.customColor(
                              FontWeight.bold, 10, Palette.primaryLighter),
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
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Flexible(
                    flex: 0,
                    child: Icon(
                      Icons.pin_drop_rounded,
                      color: Palette.primaryLighter,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            'Lokasi $coancenate',
                            style: Themes.customColor(
                                FontWeight.bold, 12, Palette.primaryLighter),
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            alamat,
                            style: Themes.customColor(
                                FontWeight.bold, 10, Palette.primaryLighter),
                            minFontSize: 5,
                            maxFontSize: 10,
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
        // Visibility(
        //   visible: alamat.isEmpty,
        //   child: Flexible(
        //     flex: 1,
        //     child: Container(
        //       width: width,
        //       padding: EdgeInsets.all(4),
        //       decoration: BoxDecoration(
        //           color: Palette.primaryDarker,
        //           borderRadius: BorderRadius.circular(10)),
        //       child: Text(
        //         'Belum absen',
        //         style: Themes.white(FontWeight.bold, 15),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
