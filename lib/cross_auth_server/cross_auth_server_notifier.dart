import 'package:dio/dio.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../shared/providers.dart';
import 'infrastructure/cross_auth_server_remote_service.dart';
import 'infrastructure/cross_auth_server_repository.dart';

part 'cross_auth_server_notifier.g.dart';

final Map<String, String> _mapPTCuti = {
  // 'gs_12': 'http://agungcartrans.co.id:1232/services',
  'gs_12': 'https://www.agunglogisticsapp.co.id:2002/services',
  'gs_14': 'https://agungcartrans.co.id:2601/services',
  'gs_18': 'https://www.agunglogisticsapp.co.id:2002/services',
  'gs_21': 'https://www.agunglogisticsapp.co.id:3603/services',
};

@Riverpod(keepAlive: true)
CrossAuthServerRemoteService crossAuthServerRemoteService(
    CrossAuthServerRemoteServiceRef ref) {
  return CrossAuthServerRemoteService(
    ref.watch(dioProviderCutiServer),
  );
}

@Riverpod(keepAlive: true)
CrossAuthServerRepository crossAuthServerRepository(
    CrossAuthServerRepositoryRef ref) {
  return CrossAuthServerRepository(
    ref.watch(crossAuthServerRemoteServiceProvider),
  );
}

@riverpod
class CrossAuthServerNotifier extends _$CrossAuthServerNotifier {
  @override
  FutureOr<Map<String, List<String>>> build() async {
    final _map = _mapPTCuti.entries.toList();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    final _list = await _iterate(
      _map,
      username,
      pass,
    );

    return _returnMap(_list);
  }

  final Map<String, List<String>> _initMap = {
    'gs_12': ['ACT', 'Transina', 'ALR'],
    'gs_14': ['Tama Raya'],
    'gs_18': ['ARV'],
    'gs_21': ['AJL'],
  };

  _returnMap(List<String> servs) {
    final Map<String, List<String>> _emptyMap = {};

    final _enries = _initMap.entries.toList();

    for (int i = 0; i < _enries.length; i++) {
      for (int j = 0; j < servs.length; j++) {
        if (_enries[i].key == servs[j]) {
          _emptyMap.addAll(({
            _enries[i].key: _enries[i].value,
          }));
        } else {
          //
        }
      }
    }

    return _emptyMap;
  }

  Future<List<String>> _iterate(
    List<MapEntry<String, String>> _map,
    String username,
    String pass,
  ) async {
    final List<String> _blacklist = [];

    for (int i = 0; i < _map.length; i++) {
      _resetCutiDioProvider(_map[i].value);

      final _resp =
          await ref.read(crossAuthServerRepositoryProvider).getCutiList(
                username: username,
                pass: pass,
              );

      _resp.fold(
        (l) => [],
        (r) => _blacklist.add(_map[i].key),
      );
    }

    return _blacklist;
  }

  Future<void> checkServer() async {
    final _map = _mapPTCuti.entries.toList();

    final username = ref.read(userNotifierProvider).user.nama!;
    final pass = ref.read(userNotifierProvider).user.password!;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final _list = await _iterate(
        _map,
        username,
        pass,
      );

      return _returnMap(_list);
    });
  }

  _resetCutiDioProvider(String baseUrl) {
    return ref.read(dioProviderCutiServer)
      ..options = BaseOptions(
        connectTimeout: 20000,
        receiveTimeout: 20000,
        validateStatus: (status) {
          return true;
        },
        baseUrl: baseUrl,
      );
  }
}
