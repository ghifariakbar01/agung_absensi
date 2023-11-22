import 'package:flutter/cupertino.dart';

import '../../style/style.dart';

class RiwayatID extends StatelessWidget {
  const RiwayatID({Key? key, required this.idAbsen, required this.idUser})
      : super(key: key);

  final String idAbsen;
  final String idUser;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          // color: Palette.primaryDarker,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID ABSEN',
                style: Themes.customColor(FontWeight.bold, 7),
              ),
              Text(
                idAbsen,
                style: Themes.customColor(FontWeight.bold, 5),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID USER',
                style: Themes.customColor(FontWeight.bold, 7),
              ),
              Text(
                idUser,
                style: Themes.customColor(FontWeight.bold, 5),
              ),
            ],
          )
        ],
      ),
    );
  }
}
