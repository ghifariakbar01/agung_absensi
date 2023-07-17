import 'dart:developer';

import 'package:face_net_authentication/pages/absen_log/absen_log_item.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/absen/absen_enum.dart';

class AbsenLogScaffold extends ConsumerWidget {
  const AbsenLogScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAbsen = ref
        .watch(autoAbsenNotifierProvider.select((value) => value.recentAbsens));

    log('{recentAbsen.length} ${recentAbsen.length}');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.primaryColor,
        title: Text(
          'Absen Log',
          style: Themes.white(FontWeight.normal, 21),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: recentAbsen.length,
            itemBuilder: ((context, index) => AbsenLogItem(
                date: recentAbsen[index].dateAbsen.toIso8601String(),
                message:
                    ' telah berhasil melakukan absen ${recentAbsen[index].jenisAbsen == JenisAbsen.absenIn ? 'masuk' : 'keluar'} jam ${recentAbsen[index].savedLocation.date.toIso8601String()}.'))),
      ),
    );
  }
}
