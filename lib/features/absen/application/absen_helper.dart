import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/providers.dart';
import '../../../widgets/v_dialogs.dart';
import '../../background/application/saved_location.dart';

import '../../tester/application/tester_state.dart';
import '../../../utils/os_vibrate.dart';

import 'absen_state.dart';

class AbsenHelper {
  final WidgetRef ref;

  AbsenHelper(this.ref);

  Future<dynamic> absen({
    required int idUser,
    required String imei,
    required String nama,
    required BuildContext context,
    required TesterState isTester,
    required List<SavedLocation> absenList,
  }) async {
    await OSVibrate.vibrate();

    final item = absenList.last;
    final isIn = absenList.last.absenState == AbsenState.empty();
    final str = isIn ? 'Masuk' : 'Pulang';

    final currDateStr = DateFormat('dd MMM yyyy').format(item.date);
    final currHourStr = DateFormat('HH:mm').format(item.dbDate);

    final savedFormat = DateFormat('dd MMM yyyy HH:mm');

    final labelStr = absenList.length != 1
        ? "$currDateStr \n $currHourStr"
        : '$currDateStr   ';
    final descStr = absenList.length != 1 ? '' : currHourStr + '\n';

    final descStrExtended = absenList.length == 1
        ? ''
        : ' Absen Tersimpan berikut juga akan diupload ke server : \n' +
            " ${absenList.map((e) => savedFormat.format(e.date))} ";

    final backgroundNotifier = ref.read(backgroundNotifierProvider.notifier);
    backgroundNotifier.reset();

    return showCupertinoDialog(
        context: context,
        builder: (_) => VAlertDialog3(
            label: '\nIngin Absen $str ?\n\n$labelStr',
            labelDescription: descStr + descStrExtended,
            labelFont: absenList.length == 1 ? 30 : 10,
            height: absenList.length == 1 ? 315 : 350,
            onBackPressedLabel: 'Tidak, Saya Ingin Menghapus Absen',
            onBackPressed: () async {
              context.pop();
              final last = await backgroundNotifier.getLastSavedLocations();
              await backgroundNotifier.removeLocationFromSaved(last);
              return backgroundNotifier.getSavedLocations();
            },
            onPressed: () async {
              context.pop();
              return isTester.maybeWhen(
                  tester: () =>
                      ref.read(absenAuthNotifierProvidier.notifier).absen(
                            imei: imei,
                            idUser: idUser,
                            nama: nama,
                            absenList: absenList,
                          ),
                  orElse: () =>
                      ref.read(absenAuthNotifierProvidier.notifier).absen(
                            imei: imei,
                            idUser: idUser,
                            nama: nama,
                            absenList: absenList,
                          ));
            })).then(
      (_) => ref.read(backgroundNotifierProvider.notifier).getSavedLocations(),
    );
  }
}
