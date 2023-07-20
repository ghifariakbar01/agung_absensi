import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../utils/geofence_utils.dart';
import '../widgets/loading_overlay.dart';
import 'absen_middle_scaffold.dart';

class AbsenPage extends HookConsumerWidget {
  const AbsenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userNotifierProvider.notifier).getUser();
      await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
      await ref.read(geofenceProvider.notifier).getGeofenceList();
    });

    final isLoading = ref.watch(
        absenAuthNotifierProvidier.select((value) => value.isSubmitting));

    return Stack(children: [
      const AbsenMiddleScaffold(),
      LoadingOverlay(isLoading: isLoading)
    ]);
  }

  Future<Placemark?> getLokasi({
    required double? latitude,
    required double? longitude,
  }) async {
    Placemark? lokasi =
        await getAddressFromCoordinates(latitude ?? 0, longitude ?? 0);

    if (lokasi == null) {
      lokasi = Placemark(
          street: 'LOCATION UKNOWN', subAdministrativeArea: '', postalCode: '');
    }

    return lokasi;
  }
}
