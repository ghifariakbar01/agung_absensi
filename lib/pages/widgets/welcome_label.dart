import 'package:flutter/material.dart';

import '../../style/style.dart';

class WelcomeLabel extends StatelessWidget {
  const WelcomeLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: Themes.grey(FontWeight.normal, 18),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
