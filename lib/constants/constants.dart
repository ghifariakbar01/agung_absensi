class Constants {
  /*
      ------------------------
      ---- Env -----
      ------------------------
  */

  static const bool isDev = false;

  /*
      ------------------------
      ---- Remote Config -----
      ------------------------
  */

  /*
     Fetch Interval
  */
  static const Duration defaultFetchTimeOut = const Duration(minutes: 1);
  static const Duration prodFetchInterval = const Duration(hours: 1);
  static const Duration devFetchInterval = const Duration(minutes: 5);

  /*
    Keys
  */
  static const String keyUrl = 'url';
  static const String keyBaseUrl = 'base_url';
  static const String keyBaseUrlHosting = 'base_url_hosting';
  static const String keyMinApp = 'min_app';
  static const String keyMinAppiOS = 'min_app_ios';
  static const String keyIosUserMaintanance = 'ios_user_maintanance';

  /*
    Values
  */
  static const String baseUrl =
      'http://180.250.79.122:1025/service_mobile.asmx/Perintah';
  static const String baseUrlHosting =
      'http://202.157.184.229:1001/service_mobile.asmx/Perintah';
  static const String iosUserMaintanance = 'non-existent';
  static const Map<String, String> ptMap = {
    "gs_12": "http://agungcartrans.co.id:1232/services",
    "gs_14": "https://agungcartrans.co.id:2601/services",
    "gs_18": "https://www.agunglogisticsapp.co.id:2002/services",
    "gs_21": "https://www.agunglogisticsapp.co.id:3603/services",
  };

  static const String minApp = '3.0.17';
  static const int passExpCode = 4;
  static const int passWrongCode = 3;
  static const int decryptErrorCode = 11;
  static const String passWrong = 'Password Wrong';
  static const String passExpString = 'Password Expired';

  static const String notRegistered = 'Sukses';
  static const String imeiAlreadyRegistered =
      'Anda belum melakukan unlink di hp sebelumnya, karena terindikasi sudah punya Installation ID. Mohon lakukan unlink dari Icon Profil dan uninstall Aplikasi. Terimakasih 🙏';
  static const String imeiNotRegistered =
      'Mohon lakukan login ulang untuk meregister imei anda, lalu lakukan absen kembali dengan tap button Jalankan Absen Tersimpan';

  static const String geofenceStorageError =
      'Mohon Maaf Storage Anda penuh. Mohon luangkan storage Anda agar bisa menyimpan data Geofence.';

  static const String keyLocation = 'location';
}
