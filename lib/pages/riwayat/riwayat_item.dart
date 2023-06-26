import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';

class RiwayatItem extends ConsumerWidget {
  const RiwayatItem(
      {required this.jenisAbsen, required this.jam, required this.alamat});

  final JenisAbsen jenisAbsen;
  final String jam;
  final String alamat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    final String coancenate =
        jenisAbsen == JenisAbsen.absenIn ? 'Masuk' : 'Keluar';

    return Column(
      children: [
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
                    Icon(Icons.alarm),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jam $coancenate',
                          style: Themes.black(FontWeight.bold, 7),
                        ),
                        Text(
                          jam,
                          style: Themes.black(FontWeight.bold, 5),
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
            child: Column(
              children: [
                // Lokasi Masuk
                Row(
                  children: [
                    Icon(Icons.pin_drop_rounded),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lokasi $coancenate',
                          style: Themes.black(FontWeight.bold, 7),
                        ),
                        Text(
                          alamat.length > 25
                              ? '${alamat.substring(0, 25)}...'
                              : alamat,
                          style: Themes.black(FontWeight.bold, 5),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
