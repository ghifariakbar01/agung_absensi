import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../style/style.dart';
import 'welome_scaffold.dart';

class WelcomeItem extends StatelessWidget {
  const WelcomeItem({
    Key? key,
    required this.homeData,
  }) : super(key: key);

  final HomeData homeData;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.pushNamed(homeData.routeNames),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Palette.primaryLighter,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    child: SvgPicture.asset(
                  homeData.icon,
                  color: Palette.primaryLighter,
                ))),
            Text(
              homeData.absen.toUpperCase(),
              style: Themes.customColor(FontWeight.bold, 9, Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
