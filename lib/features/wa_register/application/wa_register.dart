import 'package:freezed_annotation/freezed_annotation.dart';

part 'wa_register.freezed.dart';
part 'wa_register.g.dart';

@freezed
abstract class WaRegister with _$WaRegister {
  factory WaRegister({
    String? phone,
    bool? isRegistered,
  }) = _WaRegister;

  factory WaRegister.initial() => WaRegister();

  factory WaRegister.fromJson(Map<String, dynamic> json) =>
      _$WaRegisterFromJson(json);
}
