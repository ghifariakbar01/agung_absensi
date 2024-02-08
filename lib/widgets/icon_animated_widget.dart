import 'package:flutter/material.dart';

import '../../../../style/style.dart';

class IconAnimatedWidget extends StatefulWidget {
  const IconAnimatedWidget();

  @override
  State<IconAnimatedWidget> createState() => _IconAnimatedWidgetState();
}

class _IconAnimatedWidgetState extends State<IconAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat(reverse: true);
  late final Animation<Offset> _animation =
      Tween(begin: Offset.zero, end: const Offset(0.3, 0)).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _animation,
        child: const Icon(
          Icons.arrow_forward,
          color: Palette.tertiaryColor,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
