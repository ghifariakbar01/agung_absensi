import 'package:collection/collection.dart';
import 'package:face_net_authentication/lembur/create_lembur/application/create_lembur_notifier.dart';
import 'package:face_net_authentication/widgets/tappable_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../style/style.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../create_lembur/application/jenis_lembur.dart';
import '../application/lembur_list.dart';

class LemburDtlDialog extends ConsumerWidget {
  LemburDtlDialog({Key? key, required this.item}) : super(key: key);

  final LemburList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jenis = ref.watch(jenisLemburNotifierProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 280,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      item.idLmbr.toString(),
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
                        SizedBox(
                          width: 90,
                          child: Text(
                            item.comp ?? "-",
                            style: Themes.customColor(9,
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
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
                          'Departemen',
                          style: Themes.customColor(7, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            item.dept ?? '-',
                            style: Themes.customColor(9,
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 8,
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
                          'Jadwal Ganti Hari',
                          style: Themes.customColor(
                            7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        SizedBox(
                          width: 90,
                          child: VAsyncValueWidget<List<JenisLembur>>(
                            value: jenis,
                            data: (jns) => Builder(builder: (context) {
                              final selected = jns.firstWhereOrNull(
                                (element) => element.Kode == item.kategori,
                              );

                              return Text(
                                selected == null ? '-' : selected.Nama!,
                                style: Themes.customColor(9,
                                    color: item.btlSta == true
                                        ? Colors.white
                                        : Palette.orange,
                                    fontWeight: FontWeight.w500),
                              );
                            }),
                          ),
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
                          'Tanggal Lembur Awal',
                          style: Themes.customColor(
                            7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'E, dd MMM yyyy HH:MM:ss',
                          ).format(DateTime.parse(item.jamAwal!)),
                          style: Themes.customColor(9,
                              color: item.btlSta == true
                                  ? Colors.white
                                  : Palette.blue,
                              fontWeight: FontWeight.w500),
                        )
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
                          'Tanggal Lembur Akhir',
                          style: Themes.customColor(
                            7,
                            color: item.btlSta == true
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          DateFormat(
                            'E, dd MMM yyyy HH:MM:ss',
                          ).format(DateTime.parse(item.jamAkhir!)),
                          style: Themes.customColor(9,
                              color: item.btlSta == true
                                  ? Colors.white
                                  : Palette.tertiaryColor,
                              fontWeight: FontWeight.w500),
                        )
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
                          'Total Jam',
                          style: Themes.customColor(7,
                              color: item.btlSta == true
                                  ? Colors.white
                                  : Colors.grey),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Builder(builder: (_) {
                          final _total = DateTime.parse(item.jamAkhir!)
                              .difference(DateTime.parse(item.jamAwal!))
                              .inHours;

                          return Text(
                            _total.toString(),
                            style: Themes.customColor(9,
                                color: item.btlSta == true
                                    ? Colors.white
                                    : Palette.primaryColor,
                                fontWeight: FontWeight.w500),
                          );
                        }),
                      ],
                    ),
                  ],
                )
              ],
            ),
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
                  if (item.isEdit!)
                    TappableSvg(
                        assetPath: Assets.iconEdit,
                        onTap: () {
                          context.pop();
                          return context.pushNamed(
                            RouteNames.editLemburRoute,
                            extra: item.toJson(),
                          );
                        }),
                  SizedBox(
                    width: 8,
                  ),
                  if (item.isDelete!)
                    TappableSvg(
                        assetPath: Assets.iconDelete,
                        onTap: () {
                          return DialogHelper.showConfirmationDialog(
                              context: context,
                              label: 'Hapus form ? ',
                              onPressed: () async {
                                context.pop();
                                context.pop();
                                await ref
                                    .read(createLemburNotifierProvider.notifier)
                                    .deleteLembur(
                                        idLembur: item.idLmbr!,
                                        onError: (msg) {
                                          return DialogHelper.showCustomDialog(
                                            msg,
                                            context,
                                          ).then((_) => ref
                                              .read(errLogControllerProvider
                                                  .notifier)
                                              .sendLog(errMessage: msg));
                                        });
                              });
                        })
                ],
              )
          ],
        ),
      ),
    );
  }
}
