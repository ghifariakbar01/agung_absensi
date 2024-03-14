import 'package:flutter/material.dart';

import '../style/style.dart';
import '../utils/os_vibrate.dart';

class VAdditionalInfo extends StatelessWidget {
  const VAdditionalInfo({Key? key, required this.infoMessage})
      : super(key: key);

  final String infoMessage;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
          onTap: () => OSVibrate.vibrate().then((_) => showDialog(
              context: context,
              builder: (context) => Dialog(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        infoMessage,
                        style: Themes.customColor(
                          9,
                          color: Palette.primaryColor,
                        ),
                      ),
                    ),
                  ))),
          child: Icon(Icons.info)),
    );
  }
}
