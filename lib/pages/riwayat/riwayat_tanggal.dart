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
        height: 100,
        width: width,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Palette.primaryDarker,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
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
                  'Tanggal',
                  style: Themes.white(FontWeight.bold, 12),
                ),
                Text(
                  StringUtils.formatTanggal(tanggal),
                  style: Themes.white(FontWeight.bold, 10),
                ),
              ],
            )
          ],
        ));
  }
}
