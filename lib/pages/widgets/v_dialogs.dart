import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class VAlertDialog extends StatelessWidget {
  const VAlertDialog(
      {Key? key,
      required this.label,
      required this.labelDescription,
      required this.color,
      required this.onPressed})
      : super(key: key);

  final Color color;
  final String label;
  final String labelDescription;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        backgroundColor: Palette.primaryColor,
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.spaceAround,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          label,
          style: Themes.customColor(FontWeight.bold, 15, color),
        ),
        content: Text(
          labelDescription,
          style: Themes.customColor(FontWeight.bold, 20, color),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'TIDAK',
              style: Themes.customColor(FontWeight.bold, 15, color),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              'YA',
              style: Themes.customColor(FontWeight.bold, 15, color),
            ),
          ),
        ],
      ),
    );
  }
}

class VSimpleDialog extends StatelessWidget {
  const VSimpleDialog(
      {Key? key,
      required this.label,
      required this.labelDescription,
      required this.asset,
      required this.color})
      : super(key: key);

  final Color color;
  final String asset;
  final String label;
  final String labelDescription;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SimpleDialog(
        backgroundColor: Palette.primaryColor,
        title: SizedBox(height: 28, child: SvgPicture.asset(asset)),
        children: [
          SizedBox(
            height: 4,
          ),
          Center(
            child: Text(
              label,
              style: Themes.customColor(FontWeight.bold, 20, color),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Center(
            child: Text(
              labelDescription,
              style: Themes.customColor(FontWeight.bold, 15, color),
            ),
          )
        ],
      ),
    );
  }
}
