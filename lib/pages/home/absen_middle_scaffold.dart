import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/geofence_utils.dart';
import 'absen_page.dart';

class AbsenMiddleScaffold extends HookConsumerWidget {
  const AbsenMiddleScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AbsenPage();
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
