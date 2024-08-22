import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';

class RiwayatTanggal extends ConsumerWidget {
  const RiwayatTanggal({required this.tanggal});

  final String tanggal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        width: width - 48,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(
              Icons.date_range,
              size: 15,
              color: Palette.primaryColor,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              StringUtils.formatTanggal(tanggal),
              style: Themes.customColor(
                15,
                fontWeight: FontWeight.bold,
                color: Palette.primaryColor,
              ),
            )
          ],
        ));
  }
}
