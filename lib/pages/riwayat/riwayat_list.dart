import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';

import 'riwayat_item.dart';
import 'riwayat_tanggal.dart';

class RiwayatList extends StatelessWidget {
  const RiwayatList(
      {Key? key,
      required this.tanggal,
      required this.alamatMasuk,
      required this.jamMasuk,
      required this.alamatKeluar,
      required this.jamKeluar})
      : super(key: key);

  final String tanggal;
  final String? alamatMasuk;
  final String? jamMasuk;
  final String? alamatKeluar;
  final String? jamKeluar;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        height: 110,
        width: width,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Flexible(
              flex: 1,
              child: RiwayatTanggal(
                tanggal: tanggal,
              )),
          SizedBox(
            width: 4,
          ),
          Flexible(
              flex: 2,
              child: RiwayatItem(
                alamat: alamatMasuk ?? '',
                jam: jamMasuk ?? '',
              )),
        ]));
  }
}
