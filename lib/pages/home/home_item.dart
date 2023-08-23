import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../style/style.dart';
import 'home_scaffold.dart';

class WelcomeItem extends StatelessWidget {
  const WelcomeItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.pushNamed(item.routeNames),
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
                  item.icon,
                  color: Palette.primaryLighter,
                ))),
            Text(
              item.absen.toUpperCase(),
              style: Themes.customColor(FontWeight.bold, 9, Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
