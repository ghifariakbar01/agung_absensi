import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';

class AbsenLogItem extends StatelessWidget {
  const AbsenLogItem({Key? key, required this.date, required this.message})
      : super(key: key);

  final String date;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      '[$date] : $message',
      style: Themes.customColor(FontWeight.normal, 14, Colors.black),
    );
  }
}
