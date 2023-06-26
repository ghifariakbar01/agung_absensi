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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(riwayatAbsenNotifierProvider.notifier).getAbsenRiwayat(
          page: 1,
          dateFirst: StringUtils.yyyyMMddWithStripe(DateTime.now()),
          dateSecond: StringUtils.yyyyMMddWithStripe(
              DateTime.now().subtract(Duration(days: 7))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateSecond = ref.watch(
        riwayatAbsenNotifierProvider.select((value) => value.dateSecond));

    final list = ref.watch(
        riwayatAbsenNotifierProvider.select((value) => value.riwayatAbsen));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.position.notifyListeners();
      },
    );

    _scrollController.addListener(() async {
      final nextPageTrigger = 0.9 * _scrollController.position.maxScrollExtent;

      final dateFirst = ref.watch(
          riwayatAbsenNotifierProvider.select((value) => value.dateFirst));

      final dateSecond = ref.watch(
          riwayatAbsenNotifierProvider.select((value) => value.dateSecond));

      final riwayatAbsen = ref.watch(riwayatAbsenNotifierProvider);

      final isMore = riwayatAbsen.isMore;

      final isGetting = riwayatAbsen.isGetting;

      final page = riwayatAbsen.page;

      if (_scrollController.hasClients &&
          _scrollController.position.pixels > nextPageTrigger &&
          isMore &&
          !isGetting) {
        log('isGetting _scrollController.position.pixels > nextPageTrigger ${_scrollController.position.pixels > nextPageTrigger}');

        log('isGetting $isGetting');
        final endDate = DateTime.parse(dateSecond ?? '');

        final startDate = DateTime.parse(dateFirst ?? '');

        final start = StringUtils.formatTanggal(
            '${startDate.subtract(Duration(days: 7))}');
        final end =
            StringUtils.formatTanggal('${endDate.subtract(Duration(days: 7))}');

        log('start end  $start $end');

        await ref.read(riwayatAbsenNotifierProvider.notifier).startFilter(
            changePage: () => {},
            changeFilter: () => ref
                .read(riwayatAbsenNotifierProvider.notifier)
                .changeFilter(start, end),
            onAllChanged: () async => await ref
                .read(riwayatAbsenNotifierProvider.notifier)
                .getAbsenRiwayat(
                    page: page, dateFirst: start, dateSecond: end));
      }
    });

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
                        '${DateTime.now()}', dateSecond ?? ''),
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
