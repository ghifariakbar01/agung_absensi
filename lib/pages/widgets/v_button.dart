import 'package:flutter/material.dart';

import '../../../../style/style.dart';

class VButton extends StatelessWidget {
  const VButton(
      {Key? key,
      required this.label,
      this.isEnabled,
      required this.onPressed,
      this.color})
      : super(key: key);

  final String label;
  final Color? color;
  final Function() onPressed;
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    return isEnabled ?? true
        ? TextButton(
            onPressed: onPressed,
            child: Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: color ?? Palette.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  label,
                  style: Themes.whiteSpaced(
                    FontWeight.bold,
                    16,
                  ),
                ),
              ),
            ),
          )
        : TextButton(
            onPressed: () {},
            child: Container(
                height: 56,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Palette.greyDisabled,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    label,
                    style: Themes.grey(
                      FontWeight.bold,
                      16,
                    ),
                  ),
                )),
          );
  }
}
