import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/enums.dart';
import 'riwayat_item.dart';
import 'riwayat_tanggal.dart';

class RiwayatList extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isTester = ref.watch(testerNotifierProvider);

    return Container(
        height: isTester.maybeWhen(
            tester: () => 115,
            orElse: () => lokasiMasuk != 'NULL (APPLE REVIEW)' ||
                    lokasiPulang != 'NULL (APPLE REVIEW)'
                ? 208
                : 115),
        padding: EdgeInsets.all(4),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
              if (pulang.isNotEmpty && masuk.isEmpty) ...[
                Flexible(
                    flex: 0,
                    child: RiwayatTanggal(
                      tanggal: pulang.split(" ")[0],
                    )),
                SizedBox(
                  width: 4,
                ),
              ],
              SizedBox(
                height: 4,
              ),
              Flexible(
                  flex: 1,
                  child: isTester.maybeWhen(
                    // Jam Masuk & Jam Pulang
                    tester: () => Row(
                      children: [
                        if (masuk.isNotEmpty) ...[
                          Flexible(
                              flex: 1,
                              child: RiwayatItem(
                                jenisAbsen: JenisAbsen.absenIn,
                                alamat: '',
                                jam: masuk.split(" ")[1],
                              )),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                        if (pulang.isNotEmpty) ...[
                          Flexible(
                              flex: 1,
                              child: RiwayatItem(
                                jenisAbsen: JenisAbsen.absenOut,
                                alamat: '',
                                jam: pulang.split(" ")[1],
                              )),
                          SizedBox(
                            width: 4,
                          ),
                        ]
                      ],
                    ),
                    orElse: () => Row(
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
                  ))
            ]));
  }
}
