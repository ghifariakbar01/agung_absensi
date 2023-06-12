import 'package:flutter/material.dart';

import '../../style/style.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key, required this.onTap}) : super(key: key);
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: Themes.blueSpaced(
                FontWeight.bold,
                16,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Palette.secondaryColor)
          ],
        ),
      ),
    );
  }
}
