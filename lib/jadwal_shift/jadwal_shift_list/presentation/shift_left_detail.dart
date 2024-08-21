import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../style/style.dart';
import '../application/jadwal_shift_detail.dart';

class ShiftLeftDetail extends StatelessWidget {
  const ShiftLeftDetail({Key? key, required this.item}) : super(key: key);

  final JadwalShiftDetail item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ID FORM
        Text(
          'ID',
          style: Themes.customColor(7, color: Colors.grey),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          item.idShiftDtl.toString(),
          style: Themes.customColor(9,
              color: Palette.primaryColor, fontWeight: FontWeight.w500),
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
                  color: Palette.primaryColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        // TGL
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal',
              style: Themes.customColor(
                7,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              DateFormat('E, dd-MM-yyyy').format(item.tgl!),
              style: Themes.customColor(9,
                  color: Palette.primaryColor, fontWeight: FontWeight.w500),
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
              'Created',
              style: Themes.customColor(
                7,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              item.cUser == null || item.cDate == null
                  ? '-'
                  : "${item.cUser} / ${DateFormat('yyyy-MM-dd HH:mm').format(item.cDate!)}",
              style: Themes.customColor(9,
                  color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ],
        )

        //
      ],
    );
  }
}
