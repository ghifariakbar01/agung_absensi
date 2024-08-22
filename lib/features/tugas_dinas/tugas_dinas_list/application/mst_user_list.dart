import 'package:freezed_annotation/freezed_annotation.dart';

part 'mst_user_list.freezed.dart';
part 'mst_user_list.g.dart';

@freezed
class MstUserList with _$MstUserList {
  const factory MstUserList({
    @JsonKey(name: 'id_user') int? idUser,
    String? nama,
    String? fullname,
  }) = _MstUserList;

  factory MstUserList.fromJson(Map<String, dynamic> json) =>
      _$MstUserListFromJson(json);
}
