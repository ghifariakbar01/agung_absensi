import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';

class RiwayatTanggal extends ConsumerWidget {
  const RiwayatTanggal({required this.tanggal});

  final String tanggal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        width: width,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            // color: Colors.white,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(
                //
                Icons.date_range,
                size: 15,
                color: Theme.of(context)
                    .unselectedWidgetColor // // color: Palette.primaryLighter,
                ),
            SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanggal',
                  style: Themes.customColor(10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).unselectedWidgetColor),
                ),
                Text(
                  StringUtils.formatTanggal(tanggal),
                  style: Themes.customColor(
                      //
                      9,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).unselectedWidgetColor),
                ),
              ],
            )
          ],
        ));
  }
}
