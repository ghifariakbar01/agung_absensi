import 'package:face_net_authentication/style/style.dart';
import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../application/riwayat_absen_state.dart';
import 'riwayat_header.dart';
import 'riwayat_list.dart';

class RiwayatAbsenScaffold extends ConsumerStatefulWidget {
  RiwayatAbsenScaffold({required this.isFromAbsen});

  final bool? isFromAbsen;

  @override
  ConsumerState<RiwayatAbsenScaffold> createState() =>
      _RiwayatAbsenScaffoldState();
}

class _RiwayatAbsenScaffoldState extends ConsumerState<RiwayatAbsenScaffold> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isFromAbsen == null) {
        final hasOfflineData = await ref
            .read(riwayatAbsenNotifierProvider.notifier)
            .hasOfflineData();

        if (hasOfflineData) {
          await ref
              .read(riwayatAbsenNotifierProvider.notifier)
              .getAbsenRiwayatFromStorage();
        } else {
          final riwayat = RiwayatAbsenState.initial();

          await ref.read(riwayatAbsenNotifierProvider.notifier).getAbsenRiwayat(
                dateFirst: riwayat.dateFirst,
                dateSecond: riwayat.dateSecond,
              );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _riwayat = ref.watch(riwayatAbsenNotifierProvider);

    final list = _riwayat.riwayatAbsen;
    final dateFirst = _riwayat.dateFirst;
    final dateSecond = _riwayat.dateSecond;

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
            // NetworkWidget(),
            // SizedBox(
            //   width: 24,
            // )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.containerBackgroundColor.withOpacity(0.1)),
            padding: EdgeInsets.all(8),
            child: RefreshIndicator(
              onRefresh: () async {
                return ref
                    .read(riwayatAbsenNotifierProvider.notifier)
                    .getAbsenRiwayat(
                      dateFirst: dateFirst,
                      dateSecond: dateSecond,
                    );
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 4,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) => index == 0
                    ? Column(
                        children: [
                          RiwayatHeader(
                            date: StringUtils.formattedRange(
                              dateFirst ?? '',
                              dateSecond ?? '',
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RiwayatList(
                            lokasiMasuk: list[index].lokasiMasuk ?? '',
                            lokasiPulang: list[index].lokasiKeluar ?? '',
                            masuk: list[index].masuk ?? '',
                            pulang: list[index].pulang ?? '',
                            tanggal: list[index].tgl ?? '',
                          ),
                        ],
                      )
                    : RiwayatList(
                        lokasiMasuk: list[index].lokasiMasuk ?? '',
                        lokasiPulang: list[index].lokasiKeluar ?? '',
                        masuk: list[index].masuk ?? '',
                        pulang: list[index].pulang ?? '',
                        tanggal: list[index].tgl ?? '',
                      ),
              ),
            ),
          ),
        ));
  }
}
