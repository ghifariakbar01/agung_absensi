import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';

import 'riwayat_item.dart';
import 'riwayat_tanggal.dart';

class RiwayatList extends StatelessWidget {
  const RiwayatList(
      {Key? key,
      required this.tanggal,
      required this.masuk,
      required this.pulang,
      required this.lokasiMasuk,
      required this.lokasiPulang})
      : super(key: key);

  final String tanggal;
  final String masuk;
  final String lokasiMasuk;
  final String pulang;
  final String lokasiPulang;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 208,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Palette.primaryLighter,
            borderRadius: BorderRadius.circular(10)),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          if (masuk.isNotEmpty) ...[
            Flexible(
                flex: 0,
                child: RiwayatTanggal(
                  tanggal: masuk.split(" ")[0],
                )),
            SizedBox(
              width: 4,
            ),
          ],
          SizedBox(
            height: 12,
          ),
          if (masuk.isNotEmpty && lokasiMasuk.isNotEmpty) ...[
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  if (masuk.isNotEmpty && lokasiMasuk.isNotEmpty) ...[
                    Flexible(
                        flex: 1,
                        child: RiwayatItem(
                          jenisAbsen: JenisAbsen.absenIn,
                          alamat: lokasiMasuk,
                          jam: masuk.split(" ")[1],
                        )),
                    SizedBox(
                      width: 4,
                    ),
                  ],
                  if (pulang.isNotEmpty && lokasiPulang.isNotEmpty) ...[
                    Flexible(
                        flex: 1,
                        child: RiwayatItem(
                          jenisAbsen: JenisAbsen.absenOut,
                          alamat: lokasiPulang,
                          jam: pulang.split(" ")[1],
                        )),
                    SizedBox(
                      width: 4,
                    ),
                  ]
                ],
              ),
            )
          ]
        ]));
  }
}
