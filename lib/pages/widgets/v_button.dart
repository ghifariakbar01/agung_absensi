import 'package:flutter/material.dart';

import '../../../../style/style.dart';

class VButton extends StatelessWidget {
  const VButton(
      {Key? key,
      required this.label,
      this.isEnabled,
      required this.onPressed,
      this.color,
      this.height,
      this.textAlign,
      this.fontSize,
      this.textStyle})
      : super(key: key);

  final String label;
  final Color? color;
  final Function() onPressed;
  final bool? isEnabled;
  final double? height;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return isEnabled ?? true
        ? TextButton(
            onPressed: onPressed,
            child: Container(
              height: height ?? 56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: color ?? Palette.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(label,
                    style: textStyle ??
                        Themes.whiteSpaced(
                          FontWeight.bold,
                          fontSize ?? 16,
                        ),
                    textAlign: textAlign ?? TextAlign.start),
              ),
            ),
          )
        : TextButton(
            onPressed: () {},
            child: Container(
                height: height ?? 56,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Palette.greyDisabled,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    label,
                    style: textStyle ??
                        Themes.grey(
                          FontWeight.bold,
                          fontSize ?? 16,
                        ),
                    textAlign: textAlign ?? TextAlign.start,
                  ),
                )),
          );
  }
}
