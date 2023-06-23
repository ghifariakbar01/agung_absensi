import 'dart:developer';

import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/riwayat_absen/riwayat_absen_notifier.dart';
import 'riwayat_header.dart';
import 'riwayat_list.dart';

class RiwayatAbsenScaffold extends ConsumerStatefulWidget {
  RiwayatAbsenScaffold();

  @override
  ConsumerState<RiwayatAbsenScaffold> createState() =>
      _RiwayatAbsenScaffoldState();
}

class _RiwayatAbsenScaffoldState extends ConsumerState<RiwayatAbsenScaffold> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => ref
        .read(riwayatAbsenNotifierProvider.notifier)
        .getAbsenRiwayat(
            page: 1,
            dateFirst: StringUtils.yyyyMMddWithStripe(DateTime.now()),
            dateSecond: StringUtils.yyyyMMddWithStripe(
                DateTime.now().subtract(Duration(days: 7)))));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(scrollControllerProvider(_scrollController));

    final dateFirst = ref
        .watch(riwayatAbsenNotifierProvider.select((value) => value.dateFirst));

    final dateSecond = ref.watch(
        riwayatAbsenNotifierProvider.select((value) => value.dateSecond));

    final list = ref.watch(
        riwayatAbsenNotifierProvider.select((value) => value.riwayatAbsen));

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Palette.primaryColor,
          title: Text(
            'Riwayat Absen',
            style: Themes.black(FontWeight.bold, 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.primaryColor.withOpacity(0.1)),
            child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                children: [
                  RiwayatHeader(
                    date: StringUtils.formattedRange(
                        dateFirst ?? '', dateSecond ?? ''),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  for (var riwayat in list) ...[
                    RiwayatList(
                      jamKeluar: riwayat.jamAkhir,
                      jamMasuk: riwayat.jamAwal,
                      tanggal: riwayat.tgl ?? '',
                      alamatKeluar: riwayat.lokasiKeluar,
                      alamatMasuk: riwayat.lokasiMasuk,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ]
                ]),
          ),
        ));
  }
}
