import 'dart:developer';

import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/background_service/background_item_state.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/absen/absen_state.dart';
import '../../../shared/providers.dart';
import '../../../utils/string_utils.dart';
import '../../widgets/v_button.dart';
import '../../widgets/v_dialogs.dart';
import 'background_item_detail.dart';

class BackgroundItem extends ConsumerWidget {
  const BackgroundItem({Key? key, required this.index, required this.item})
      : super(key: key);

  final BackgroundItemState item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearest = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.remainingDistance));

    final minDistance = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.minDistance));

    final width = MediaQuery.of(context).size.width;

    final location = item.savedLocations;

    final date = item.savedLocations.date.toString();

    log('nearest $nearest');
    log('item.savedLocations ${item.savedLocations}');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Palette.primaryColor.withOpacity(0.1),
        ),
        padding: EdgeInsets.all(4),
        child: Column(
          children: [
            SizedBox(
              width: 4,
            ),

            Flexible(
              flex: 1,
              child: BackgroundItemDetail(
                alamat: location.alamat ?? '',
                latitude: location.latitude.toString(),
                longitude: location.longitude.toString(),
                date: location.date.toString(),
              ),
            ),

            SizedBox(
              width: 4,
            ),

            //
            ...[
              if (item.abenStates == AbsenState.empty() &&
                      nearest < minDistance &&
                      nearest != 0 ||
                  item.abenStates == AbsenState.incomplete() &&
                      nearest < minDistance &&
                      nearest != 0) ...[
                Flexible(
                  flex: 1,
                  child: VButton(
                      label: 'ABSEN IN',
                      onPressed: () => showCupertinoDialog(
                          context: context,
                          builder: (_) => VAlertDialog(
                              label: 'Ingin absen-in ?',
                              labelDescription:
                                  'JAM: ${StringUtils.hoursDate(DateTime.parse(date))}',
                              onPressed: () async {
                                context.pop();

                                debugger(message: 'called');

                                ref
                                    .read(absenAuthNotifierProvidier.notifier)
                                    .changeBackgroundAbsenStateSaved(item);

                                await ref
                                    .read(absenAuthNotifierProvidier.notifier)
                                    .absenAndUpdateSaved(
                                        jenisAbsen: JenisAbsen.absenIn);

                                await ref
                                    .read(backgroundNotifierProvider.notifier)
                                    .getSavedLocations();
                              }))),
                )
              ] else if (item.abenStates == AbsenState.empty() &&
                      nearest < minDistance &&
                      nearest != 0 ||
                  item.abenStates == AbsenState.incomplete() &&
                      nearest < minDistance &&
                      nearest != 0 ||
                  item.abenStates == AbsenState.absenIn() &&
                      nearest < minDistance &&
                      nearest != 0) ...[
                Flexible(
                  flex: 1,
                  child: VButton(
                      label: 'ABSEN OUT',
                      onPressed: () => showCupertinoDialog(
                          context: context,
                          builder: (_) => VAlertDialog(
                              label: 'Ingin absen-out ?',
                              labelDescription:
                                  'JAM: ${StringUtils.hoursDate(DateTime.parse(date))}',
                              onPressed: () async {
                                context.pop();

                                debugger(message: 'called');

                                ref
                                    .read(absenAuthNotifierProvidier.notifier)
                                    .changeBackgroundAbsenStateSaved(item);

                                await ref
                                    .read(absenAuthNotifierProvidier.notifier)
                                    .absenAndUpdateSaved(
                                        jenisAbsen: JenisAbsen.absenOut);

                                await ref
                                    .read(backgroundNotifierProvider.notifier)
                                    .getSavedLocations();
                              }))),
                )
              ] else if (item.abenStates == AbsenState.complete()) ...[
                Flexible(
                  flex: 1,
                  child: VButton(
                      label: 'ABSEN OUT',
                      isEnabled: false,
                      onPressed: () => {}),
                )
              ],
              SizedBox(
                width: 4,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
