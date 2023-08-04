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
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
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
                  'Tanggal',
                  style: Themes.customColor(
                      FontWeight.bold, 12, Palette.primaryLighter),
                ),
                Text(
                  StringUtils.formatTanggal(tanggal),
                  style: Themes.customColor(
                      FontWeight.bold, 10, Palette.primaryLighter),
                ),
              ],
            )
          ],
        ));
  }
}
