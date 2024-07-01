import 'package:flutter/material.dart';

import '../shared/common_widgets.dart';
import '../utils/os_vibrate.dart';

class VAdditionalInfo extends StatelessWidget {
  const VAdditionalInfo({Key? key, required this.infoMessage})
      : super(key: key);

  final List<List<String>> infoMessage;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        child: Icon(Icons.info),
        onTap: () => OSVibrate.vibrate().then((_) => showDialog(
            context: context,
            builder: (context) => Dialog(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: EdgeInsets.all(8),
                    child: CommonWidget().information(infoMessage),
                  ),
                ))),
      ),
    );
  }
}
