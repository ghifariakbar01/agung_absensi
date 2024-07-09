import 'package:upgrader/upgrader.dart';

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get body => 'Mohon Lakukan update dengan versi aplikasi terbaru';

  @override
  String get buttonTitleIgnore => '-';

  @override
  String get title => 'Ada Pembaharuan';

  @override
  String get buttonTitleUpdate => 'Update';

  @override
  String get buttonTitleLater => 'Nanti Saja';

  @override
  String get prompt => '';
}
