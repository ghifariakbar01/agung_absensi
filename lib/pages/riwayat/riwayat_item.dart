import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';

class RiwayatItem extends ConsumerWidget {
  const RiwayatItem({required this.jam, required this.alamat});

  final String jam;
  final String alamat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if (alamat.isNotEmpty) ...[
          Flexible(
            flex: 1,
            child: Container(
              width: width,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Palette.primaryDarker,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  // Jam Masuk
                  Row(
                    children: [
                      Icon(
                        Icons.alarm,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jam',
                            style: Themes.white(FontWeight.bold, 12),
                          ),
                          Text(
                            jam,
                            style: Themes.white(FontWeight.bold, 10),
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
          Flexible(
            flex: 1,
            child: Container(
              width: width,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Palette.primaryDarker,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Icon(
                      Icons.pin_drop_rounded,
                      color: Colors.white,
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
                            'Lokasi',
                            style: Themes.white(FontWeight.bold, 12),
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            alamat,
                            style: Themes.white(FontWeight.bold, 10),
                            minFontSize: 5,
                            maxFontSize: 10,
                            maxLines: 2,
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
