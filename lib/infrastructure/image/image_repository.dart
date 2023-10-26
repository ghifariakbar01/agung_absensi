import 'package:face_net_authentication/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_repository.g.dart';

class ImageRepository {
  const ImageRepository();

  String imageUrl({required String port, required String idGeof}) =>
      'http://agunglogisticsapp.co.id:$port/img_geof.aspx?id_geof=$idGeof&pass=passwordAgung2023';

  Map<String, String> _imagePtServerMap() =>
      {'gs_12': '1232', 'gs_14': '1261', 'gs_18': '1026', 'gs_21': '1063'};

  String getPort({
    required String ptServer,
  }) =>
      _imagePtServerMap()
          .entries
          .toList()
          .firstWhere((element) => element.key == ptServer)
          .value;
}

@riverpod
ImageRepository imageRepository(ImageRepositoryRef ref) {
  return ImageRepository();
}

@riverpod
String imageUrl(ProviderRef ref) {
  final ptServer =
      ref.watch(userNotifierProvider.select((value) => value.user.ptServer));
  final idGeof = ref
      .watch(geofenceProvider.select((value) => value.nearestCoordinates.id));

  final repository = ref.read(imageRepositoryProvider);

  String port = repository.getPort(ptServer: ptServer);

  return repository.imageUrl(port: port, idGeof: idGeof);
}
