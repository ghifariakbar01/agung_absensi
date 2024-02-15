import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../routes/application/route_names.dart';
import '../../../style/style.dart';
import '../../../widgets/v_async_widget.dart';
import '../../create_cuti/application/alasan_cuti.dart';
import '../../create_cuti/application/create_cuti_notifier.dart';
import '../../create_cuti/application/jenis_cuti.dart';
import '../application/cuti_list.dart';

class CutiDtlDialog extends ConsumerWidget {
  CutiDtlDialog({Key? key, required this.item}) : super(key: key);

  final CutiList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jenisCuti = ref.watch(jenisCutiNotifierProvider);
    final alasanCuti = ref.watch(alasanCutiNotifierProvider);
    //
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 280,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // 1.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID FORM
                    Text(
                      'ID Form',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      item.idCuti.toString(),
                      style: Themes.customColor(9,
                          color: Palette.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // NAMA
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          item.fullname!,
                          style: Themes.customColor(9,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // PT
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PT',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          item.comp ?? "-",
                          style: Themes.customColor(9,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // DEPT
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Departemen',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          item.dept!,
                          style: Themes.customColor(9,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    //
                  ],
                ),
                //
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Awal',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(DateTime.parse(item.tglStart!)),
                          style: Themes.customColor(9,
                              color: Palette.blue, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // TGL AKHIR
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Akhir',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(DateTime.parse(item.tglStart!)),
                          style: Themes.customColor(9,
                              color: Palette.tertiaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // JML HARI
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jumlah Hari',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          item.totalHari!.toString() + " Hari",
                          style: Themes.customColor(9,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jenis Cuti',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        VAsyncValueWidget<List<JenisCuti>>(
                          value: jenisCuti,
                          data: (list) => Text(
                            '${list.firstWhere((element) => element.inisial == item.jenisCuti, orElse: () => list.first).nama}',
                            style: Themes.customColor(9,
                                color: Palette.tertiaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 8,
            ),
            // 5
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alasan Cuti',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    VAsyncValueWidget<List<AlasanCuti>>(
                      value: alasanCuti,
                      data: (list) => SizedBox(
                        width: 150,
                        child: Text(
                          '${list.firstWhere((element) => element.kode == item.alasan, orElse: () => list.first).alasan}',
                          style: Themes.customColor(9,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            // 6
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keterangan',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        '${item.ket}',
                        style: Themes.customColor(9,
                            color: Palette.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(child: Container()),
            if (item.btlSta == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TappableSvg(
                      assetPath: Assets.iconEdit,
                      onTap: () {
                        context.pop();
                        return context.pushNamed(RouteNames.editCutiRoute,
                            extra: item);
                      }),
                  SizedBox(
                    width: 8,
                  ),
                  TappableSvg(assetPath: Assets.iconDelete, onTap: () {})
                ],
              )
          ],
        ),
      ),
    );
  }
}
