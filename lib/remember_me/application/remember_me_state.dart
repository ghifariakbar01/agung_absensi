import 'package:freezed_annotation/freezed_annotation.dart';

part 'remember_me_state.freezed.dart';

part 'remember_me_state.g.dart';

@freezed
class RememberMeModel with _$RememberMeModel {
  const factory RememberMeModel({
    required String nik,
    required String nama,
    required String password,
    required String ptName,
    required bool isKaryawan,
  }) = _RememberMeModel;

  factory RememberMeModel.fromJson(Map<String, Object?> json) =>
      _$RememberMeModelFromJson(json);
}
