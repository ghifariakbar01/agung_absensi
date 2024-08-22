import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../ganti_hari/create_ganti_hari/application/absen_ganti_hari.dart';
import '../../../ganti_hari/create_ganti_hari/application/create_ganti_hari_notifier.dart';
import '../../../../style/style.dart';
import '../../../../widgets/v_async_widget.dart';
import '../application/jadwal_shift_detail.dart';
import 'shift_left_detail.dart';

class JadwalShiftDtlItem extends HookConsumerWidget {
  const JadwalShiftDtlItem({
    required this.item,
    required this.onChanged,
  });

  final JadwalShiftDetail item;
  final Function(JadwalShiftDetail nama) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final param = useState(item);
    final absenGantiHari = ref.watch(absenGantiHariNotifierProvider);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: ShiftLeftDetail(item: item)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Jadwal
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jadwal',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 50,
                      child: VAsyncValueWidget<List<AbsenGantiHari>>(
                        value: absenGantiHari,
                        data: (absen) =>
                            DropdownButtonFormField<AbsenGantiHari>(
                          isExpanded: true,
                          elevation: 0,
                          iconSize: 11,
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Palette.primaryColor,
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          },
                          value: absen.firstWhere(
                            (element) =>
                                element.nama.toString() == param.value.jadwal,
                            orElse: () => absen.first,
                          ),
                          onChanged: (AbsenGantiHari? value) {
                            if (value != null) {
                              final newItem = item.copyWith(jadwal: value.nama);

                              onChanged(newItem);
                              param.value = newItem;
                            }
                          },
                          items: absen.map<DropdownMenuItem<AbsenGantiHari>>(
                              (AbsenGantiHari value) {
                            return DropdownMenuItem<AbsenGantiHari>(
                              value: value,
                              child: Text(
                                '${value.nama} | ${value.jdwIn} | ${value.jdwOut}',
                                style: Themes.customColor(
                                  9,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                // Jadwal In / Out
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'In',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      item.jdwlIn ?? '-',
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
                      'Out',
                      style: Themes.customColor(7, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      item.jdwlOut ?? '-',
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
                      'Updated',
                      style: Themes.customColor(
                        7,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      item.uUser == null || item.uDate == null
                          ? '-'
                          : "${item.uUser} / ${DateFormat('yyyy-MM-dd HH:mm').format(item.uDate!)}",
                      style: Themes.customColor(9,
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
