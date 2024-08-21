import 'package:flutter/material.dart';

import '../../../style/style.dart';

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
      this.fontWeight,
      this.textStyle})
      : super(key: key);

  final String label;
  final Color? color;
  final Function() onPressed;
  final bool? isEnabled;
  final FontWeight? fontWeight;
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
                  borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(label,
                    style: textStyle ??
                        Themes.customColor(fontSize ?? 16,
                            fontWeight: fontWeight ?? FontWeight.bold,
                            color: Colors.white),
                    textAlign: textAlign ?? TextAlign.center),
              ),
            ),
          )
        : TextButton(
            onPressed: () {},
            child: Container(
                height: height ?? 56,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Text(
                    label,
                    textAlign: textAlign ?? TextAlign.center,
                    style: textStyle ??
                        Themes.customColor(fontSize ?? 16,
                            fontWeight: fontWeight ?? FontWeight.bold,
                            color: Theme.of(context).disabledColor),
                  ),
                )),
          );
  }
}
