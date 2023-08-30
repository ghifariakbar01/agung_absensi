import 'package:ntp/ntp.dart';

class TimeUtil {
  static Future<DateTime> getOnlineTime() async {
    DateTime startDate = new DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    return startDate.add(new Duration(milliseconds: offset));
  }
}
