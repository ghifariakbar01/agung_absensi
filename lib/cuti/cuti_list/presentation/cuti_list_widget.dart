import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../mst_karyawan_cuti/application/mst_karyawan_cuti.dart';
import '../../../style/style.dart';
import '../application/cuti_list.dart';
import 'cuti_list_item.dart';

class CutiListWidget extends ConsumerWidget {
  const CutiListWidget(
    this._isCrossed,
    this.mst,
    this.list,
    this.onRefresh,
    this.scrollController,
  );

  final bool _isCrossed;
  final MstKaryawanCuti mst;
  final List<CutiList> list;
  final Future<void> Function() onRefresh;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: list.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 16.0, right: 16.0, bottom: 0),
                child: Container(
                  height: 100,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Palette.greyDisabled.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isCrossed
                      ? Center(
                          child: Text(
                            'Sedang Melintas Server',
                            style: Themes.customColor(8,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                "1. Cuti Tahunan wajib diinput paling lambat H-5.\n"
                                "2. Persetujuan atasan paling lambat H+3 dari Tanggal penginputan Cuti.\n"
                                "3. Cuti Emergency dan Cuti Bersama dapat diinput pada hari H.\n"
                                "4. Total Hari dihitung berdasarkan Hari Kerja. (Tidak termasuk Tanggal Merah) '",
                                style: Themes.customColor(8,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Saldo Cuti \n(${mst.dateOpen} )',
                                  style: Themes.customColor(10,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${mst.cutiAktif}',
                                  style: Themes.customColor(20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                ),
              )
            : ListView.separated(
                controller: scrollController,
                separatorBuilder: (__, index) => SizedBox(
                      height: 8,
                    ),
                itemCount: list.length + 1,
                itemBuilder: (BuildContext context, int index) => index ==
                        list.length
                    ? SizedBox(
                        height: 50,
                      )
                    : index == 0
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 16.0,
                                    right: 16.0,
                                    bottom: 0),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        Palette.greyDisabled.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: _isCrossed
                                      ? Center(
                                          child: Text(
                                            'Sedang Melintas Server',
                                            style: Themes.customColor(8,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                "1. Cuti Tahunan wajib diinput paling lambat H-5.\n"
                                                "2. Persetujuan atasan paling lambat H+3 dari Tanggal penginputan Cuti.\n"
                                                "3. Cuti Emergency dan Cuti Bersama dapat diinput pada hari H.\n"
                                                "4. Total Hari dihitung berdasarkan Hari Kerja. (Tidak termasuk Tanggal Merah) '",
                                                style: Themes.customColor(8,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Saldo Cuti \n(${mst.cutiBaru != 0 ? mst.tahunCutiBaru : mst.tahunCutiTidakBaru} )',
                                                  style: Themes.customColor(10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  '${mst.cutiBaru != 0 ? mst.cutiBaru : mst.cutiTidakBaru}',
                                                  style: Themes.customColor(20,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CutiListItem(list[index])
                            ],
                          )
                        : CutiListItem(list[index])));
  }
}
