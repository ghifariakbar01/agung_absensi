import 'package:face_net_authentication/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/constants.dart';
import '../../../features/user/application/user_model.dart';

part 'image_repository.g.dart';

class ImageRepository {
  const ImageRepository();

  String imageUrl({
    required String baseUrl,
    required String idGeof,
  }) {
    return '$baseUrl/img_geof.aspx?id_geof=$idGeof&pass=passwordAgung2023';
  }

  Map<String, String> _imagePtServerMap() => {
        'gs_12': '1232',
        'gs_14': '1261',
        'gs_18': '1026',
        'gs_21': '1063',
      };

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
  final user = ref.watch(userNotifierProvider.select(
    (value) => value.user,
  ));
  final idGeof = ref.watch(geofenceProvider.select(
    (value) => value.nearestCoordinates.id,
  ));

  final _url = _determineBaseUrl(user);

  return ref.read(imageRepositoryProvider).imageUrl(
        baseUrl: _url,
        idGeof: idGeof,
      );
}

_determineBaseUrl(UserModelWithPassword user) {
  final pt = user.ptServer;
  if (pt == null) {
    throw AssertionError('pt null');
  }

  return Constants.ptMap.entries
      .firstWhere(
        (element) => element.key == pt,
        orElse: () => Constants.ptMap.entries.first,
      )
      .value
      .replaceAll('/services', '');
}
