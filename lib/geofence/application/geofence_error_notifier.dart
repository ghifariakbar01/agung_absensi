import 'package:face_net_authentication/geofence/application/geofence_error_state.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'geofence_error_notifier.g.dart';

@riverpod
class GeofenceErrorNotifier extends _$GeofenceErrorNotifier {
  @override
  FutureOr<GeofenceErrorState> build() async {
    return GeofenceErrorState.ALREADY_STARTED();
  }

  String geofenceErrMessage(ErrorCodes errorCode) {
    switch (errorCode) {
      case ErrorCodes.ALREADY_STARTED:
        return '';

      case ErrorCodes.LOCATION_PERMISSION_DENIED:
        return 'Mohon nyalakan izin lokasi E-FINGER.';

      case ErrorCodes.LOCATION_PERMISSION_PERMANENTLY_DENIED:
        return 'Mohon nyalakan izin lokasi E-FINGER.';

      case ErrorCodes.LOCATION_SERVICES_DISABLED:
        return 'Pastikan GPS Menyala & Tidak dalam mode Battery Saver / Penghemat Baterai.\n';

      default:
        return '';
    }
  }

  checkAndUpdateError(ErrorCodes errorCode) {
    state = const AsyncLoading();

    switch (errorCode) {
      case ErrorCodes.ALREADY_STARTED:
        state = AsyncValue.data(GeofenceErrorState.ALREADY_STARTED());
        break;

      case ErrorCodes.LOCATION_PERMISSION_DENIED:
        state =
            AsyncValue.data(GeofenceErrorState.LOCATION_PERMISSION_DENIED());
        break;

      case ErrorCodes.LOCATION_PERMISSION_PERMANENTLY_DENIED:
        state = AsyncValue.data(
            GeofenceErrorState.LOCATION_PERMISSION_PERMANENTLY_DENIED());
        break;

      case ErrorCodes.LOCATION_SERVICES_DISABLED:
        state =
            AsyncValue.data(GeofenceErrorState.LOCATION_SERVICES_DISABLED());
        break;

      default:
        break;
    }
  }
}
