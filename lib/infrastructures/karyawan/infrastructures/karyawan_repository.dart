import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/domain/user_failure.dart';
import '../../../features/remember_me/application/remember_me_state.dart';

class KaryawanShiftRepository {
  KaryawanShiftRepository();

  Future<bool> isKaryawanShift() => getIsKaryawan().then(
      (value) => value.fold((_) => false, (isKaryawan) => isKaryawan ?? false));

  Future<Either<UserFailure, bool?>> getIsKaryawan() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final rememberMe = await prefs.getString('remember_me');

      if (rememberMe != null) {
        final json = jsonDecode(rememberMe);

        final rememberMeModel = RememberMeModel.fromJson(json);

        return right(rememberMeModel.isKaryawan);
      }

      return right(null);
    } on FormatException {
      return left(UserFailure.errorParsing('Error while parsing'));
    } on PlatformException {
      return left(UserFailure.unknown(0, 'Platform exception while reading'));
    }
  }
}
