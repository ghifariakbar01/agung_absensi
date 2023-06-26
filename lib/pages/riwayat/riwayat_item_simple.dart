import 'package:flutter/material.dart';

import '../../style/style.dart';

class RiwayatItemSimple extends StatelessWidget {
  const RiwayatItemSimple({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Palette.primaryDarker,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Themes.black(FontWeight.bold, 7),
          ),
          Text(
            message,
            style: Themes.black(FontWeight.bold, 5),
          ),
        ],
      ),
    );
  }
}
