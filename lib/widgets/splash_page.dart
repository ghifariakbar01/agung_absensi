import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(48),
        child: Center(
          child: LinearProgressIndicator(),
        ),
      ),
    );
  }
}
