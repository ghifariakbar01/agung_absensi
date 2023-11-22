import 'package:flutter/material.dart';

import '../../style/style.dart';

class RiwayatSpvHeader extends StatelessWidget {
  const RiwayatSpvHeader(
      {required this.nama, required this.notes, required this.tanggal});

  final String nama;
  final String? notes;
  final String tanggal;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          // color: Palette.primaryDarker,
          borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                Text(
                  'Tanggal',
                  style: Themes.customColor(FontWeight.bold, 7),
                ),
                Text(
                  tanggal,
                  style: Themes.customColor(FontWeight.bold, 5),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                'SPV',
                style: Themes.customColor(FontWeight.bold, 7),
              ),
              Text(
                nama,
                style: Themes.customColor(FontWeight.bold, 5),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Notes',
                style: Themes.customColor(FontWeight.bold, 7),
              ),
              Text(
                notes ?? '-',
                style: Themes.customColor(FontWeight.bold, 5),
              ),
            ],
          )
        ],
      ),
    );
  }
}
