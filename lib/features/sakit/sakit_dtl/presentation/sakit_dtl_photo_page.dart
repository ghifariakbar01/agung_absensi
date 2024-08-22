import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../shared/webview_widget.dart';

class SakitDtlPhotoPage extends HookWidget {
  const SakitDtlPhotoPage({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final rotate = useState(0);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                icon: Icon(Icons.rotate_90_degrees_ccw),
                onPressed: () =>
                    rotate.value == 4 ? rotate.value = 0 : rotate.value++,
              ),
            )
          ],
        ),
        body: RotatedBox(
          quarterTurns: rotate.value,
          child: WebViewCustom(imageUrl),
        ),
      ),
    );
  }
}
