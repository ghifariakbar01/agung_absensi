import 'package:dio/dio.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/configuration.dart';

part 'ip_notifier.g.dart';

const ip = 'http://180.250.79.122:1025/service_mobile.asmx/Perintah';
const ipHosting = 'http://202.157.184.229:1001/service_mobile.asmx/Perintah';

// API Mobile Cutmutiah:
// http://agunglogisticsapp.co.id:1225/service_mobile.asmx/Perintah
// http://180.250.79.122:1225/service_mobile.asmx/Perintah
// const domainCut =
//     'http://agunglogisticsapp.co.id:1225/service_mobile.asmx/Perintah';

// const ipCut = 'http://202.157.184.229:1001/service_mobile.asmx/Perintah';

// API Mobile Priuk :
// http://agunglogisticsapp.co.id:1025/service_mobile.asmx/Perintah
// http://118.97.100.75:1025/service_mobile.asmx/Perintah
// untuk ARV, AJL
// const domainPriyok =
//     'http://agunglogisticsapp.co.id:1025/service_mobile.asmx/Perintah';

// const ipPriyok = 'http://118.97.100.75:1025/service_mobile.asmx/Perintah';

// [16:35, 18/12/2023] Pak Ismu: oke gini gs_18 dan gs_21 diarahkan ke http://118.97.100.75:1025/service_mobile.asmx/Perintah
// [16:36, 18/12/2023] Pak Ismu: gs_12, gs_14, gs_16 diarahkan ke http://180.250.79.122:1025/service_mobile.asmx/Perintah

@riverpod
class IpNotifier extends _$IpNotifier {
  @override
  FutureOr<void> build() async {
    initOnLogin();
  }

  initOnLogin() {
    ref.read(dioProvider)
      ..options = BaseOptions(
        connectTimeout: BuildConfig.get().connectTimeout,
        receiveTimeout: BuildConfig.get().receiveTimeout,
        validateStatus: (status) {
          return true;
        },
        baseUrl: ip,
      )
      ..interceptors.add(ref.read(authInterceptorProvider));

    ref.read(dioProviderHosting)
      ..options = BaseOptions(
        connectTimeout: BuildConfig.get().connectTimeout,
        receiveTimeout: BuildConfig.get().receiveTimeout,
        validateStatus: (status) {
          return true;
        },
        baseUrl: ipHosting,
      )
      ..interceptors.add(ref.read(authInterceptorProvider));
  }
}
