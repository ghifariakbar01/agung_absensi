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
                  style: Themes.customColor(7, fontWeight: FontWeight.bold),
                ),
                Text(
                  tanggal,
                  style: Themes.customColor(5, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                'SPV',
                style: Themes.customColor(7, fontWeight: FontWeight.bold),
              ),
              Text(
                nama,
                style: Themes.customColor(5, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Notes',
                style: Themes.customColor(7, fontWeight: FontWeight.bold),
              ),
              Text(
                notes ?? '-',
                style: Themes.customColor(5, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
