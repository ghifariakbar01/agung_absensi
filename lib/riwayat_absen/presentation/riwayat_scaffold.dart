import 'dart:developer';

import 'package:face_net_authentication/style/style.dart';
import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../widgets/network_widget.dart';
import '../application/riwayat_absen_notifier.dart';
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
      await ref.read(testerNotifierProvider).maybeWhen(
          forcedRegularUser: () {},
          orElse: () => ref
              .read(testerNotifierProvider.notifier)
              .checkAndUpdateTesterState());

      await ref.read(riwayatAbsenNotifierProvider.notifier).getAbsenRiwayat(
          page: 1,
          dateFirst: StringUtils.yyyyMMddWithStripe(
              DateTime.now().add(Duration(days: 1))),
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
        log('isGetting $isGetting');

        final endDate = DateTime.parse(dateSecond ?? '');

        final startDate = DateTime.parse(dateFirst ?? '');

        final start = StringUtils.formatTanggal(
            '${startDate.subtract(Duration(days: 7))}');

        final end =
            StringUtils.formatTanggal('${endDate.subtract(Duration(days: 6))}');

        await ref.read(riwayatAbsenNotifierProvider.notifier).startFilter(
            changePage: () => ref
                .read(riwayatAbsenNotifierProvider.notifier)
                .changePage(page + 1),
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
          elevation: 0,
          backgroundColor: Palette.tertiaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Riwayat Absen',
            style: Themes.customColor(20,
                fontWeight: FontWeight.w500, color: Colors.white),
          ),
          toolbarHeight: 45,
          actions: [
            NetworkWidget(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.containerBackgroundColor.withOpacity(0.1)),
            padding: EdgeInsets.all(8),
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
                      lokasiMasuk: riwayat.lokasiMasuk ?? '',
                      lokasiPulang: riwayat.lokasiKeluar ?? '',
                      masuk: riwayat.masuk ?? '',
                      pulang: riwayat.pulang ?? '',
                      tanggal: riwayat.tgl ?? '',
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
