import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../style/style.dart';
import 'icon_animated_widget.dart';

class ProceedWidget extends ConsumerWidget {
  const ProceedWidget(
    this.onPressed,
    this.title,
  );

  final Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Text(
            '$title ',
            style: Themes.blue(FontWeight.normal, 14),
          ),
          const SizedBox(
            width: 2,
          ),
          const IconAnimatedWidget()
        ],
      ),
    );
  }
}
