import 'package:json_annotation/json_annotation.dart';

enum StatusAbsen { sukses, gagal, dihapus }

enum JenisAbsen {
  @JsonValue("in")
  absenIn,
  @JsonValue("out")
  absenOut,
  @JsonValue("unknown")
  unknown
}
