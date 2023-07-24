import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class VAlertDialog extends StatelessWidget {
  const VAlertDialog({
    Key? key,
    required this.label,
    required this.labelDescription,
    required this.onPressed,
    this.onBackPressed,
    this.backPressedLabel,
  }) : super(key: key);

  final String label;
  final String labelDescription;
  final String? backPressedLabel;
  final Function() onPressed;
  final Function()? onBackPressed;

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
          style: Themes.white(
            FontWeight.bold,
            20,
          ),
        ),
        content: Text(
          labelDescription,
          style: Themes.white(
            FontWeight.bold,
            15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: onBackPressed ?? () => context.pop(),
            child: Text(
              backPressedLabel ?? 'TIDAK',
              style: Themes.white(
                FontWeight.bold,
                15,
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              'YA',
              style: Themes.white(
                FontWeight.bold,
                15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VSimpleDialog extends StatelessWidget {
  const VSimpleDialog({
    Key? key,
    required this.label,
    required this.labelDescription,
    required this.asset,
    this.color,
  }) : super(key: key);

  final Color? color;
  final String asset;
  final String label;
  final String labelDescription;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SimpleDialog(
        backgroundColor: color ?? Palette.primaryColor,
        title: SizedBox(height: 28, child: SvgPicture.asset(asset)),
        children: [
          SizedBox(
            height: 4,
          ),
          Center(
            child: Text(
              label,
              style: Themes.white(FontWeight.bold, 20),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                labelDescription,
                style: Themes.white(FontWeight.bold, 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
