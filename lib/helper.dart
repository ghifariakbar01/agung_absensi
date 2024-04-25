import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Helper {
  Future<void> fixStorageOnAndroidDevices(Ref ref) async {}
}

class HelperImpl implements Helper {
  @override
  Future<void> fixStorageOnAndroidDevices(Ref<Object?> ref) async {
    //
    Future<Unit> _saveCurrentImei(String? imei) async {
      if (imei == null) {
        return unit;
      } else {
        await ref.read(imeiCredentialsStorageProvider).save(imei);
        return unit;
      }
    }

    Future<String?> _getCurrentImei() async {
      return ref.read(imeiCredentialsStorageProvider).read();
    }

    Future<Unit> _deleteAll() async {
      await ref.read(flutterSecureStorageProvider).deleteAll();
      return unit;
    }

    final prefs = await SharedPreferences.getInstance();
    const String name = 'first_run';

    if (prefs.getBool(name) ?? true) {
      final String? _imei = await _getCurrentImei();
      await _deleteAll();
      await _saveCurrentImei(_imei);

      prefs.setBool(name, false);
    }
  }
}
