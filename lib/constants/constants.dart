class Constants {
  static const String keyBaseUrl = 'base_url';
  static const String keyBaseUrlHosting = 'base_url_hosting';
  static const String keyMinApp = 'min_app';
  static const String keyMinAppiOS = 'min_app_ios';

  static const Duration defaultFetchTimeOut = const Duration(minutes: 1);
  static const Duration prodFetchInterval = const Duration(hours: 1);
  static const Duration devFetchInterval = const Duration(minutes: 5);

  static const String baseUrl =
      'http://180.250.79.122:1025/service_mobile.asmx/Perintah';
  static const String baseUrlHosting =
      'http://202.157.184.229:1001/service_mobile.asmx/Perintah';
  static const String minApp = '1.2.6';
  static const int passExpCode = 4;
  static const int passWrongCode = 3;
  static const String passWrong = 'Password Wrong';
  static const String passExpString = 'Password Expired';
}
