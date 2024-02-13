import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_num.freezed.dart';
part 'phone_num.g.dart';

@freezed
abstract class PhoneNum with _$PhoneNum {
  const factory PhoneNum({
    @JsonKey(name: 'no_telp1') String? noTelp1,
    @JsonKey(name: 'no_telp2') String? noTelp2,
  }) = _PhoneNum;

  factory PhoneNum.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumFromJson(json);
}
