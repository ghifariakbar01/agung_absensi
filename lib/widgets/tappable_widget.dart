import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TappableSvg extends StatelessWidget {
  const TappableSvg(
      {Key? key, required this.assetPath, required this.onTap, this.color})
      : super(key: key);

  final String assetPath;
  final Function() onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 11,
      width: 12,
      child: Stack(
        children: <Widget>[
          new Positioned.fill(
            bottom: 0.0,
            child: SvgPicture.asset(
              assetPath,
              color: color ?? null,
            ),
          ),
          new Positioned.fill(
            child: new Material(
              color: Colors.transparent,
              child: new InkWell(
                splashColor: Palette.primaryColor,
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
