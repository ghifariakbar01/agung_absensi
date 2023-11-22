import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';

class RiwayatDelayed extends ConsumerWidget {
  const RiwayatDelayed({required this.jenisAbsen});

  final JenisAbsen jenisAbsen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    final String coancenate = jenisAbsen == JenisAbsen.absenIn ? '' : 'keluar';

    return Container(
        height: 65,
        width: width,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            // color: Palette.primaryDarker,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.verified,
              color: Colors.white,
            ),
            Text(
              'Belum absen\n $coancenate',
              style: Themes.customColor(FontWeight.bold, 7),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
