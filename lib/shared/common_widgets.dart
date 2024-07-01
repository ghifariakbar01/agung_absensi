import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../style/style.dart';

class CommonWidget {
  lottie(
    String asset,
    String message,
    AnimationController _controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          asset,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward()
              ..repeat();
          },
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          message,
          style: Themes.customColor(
            20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  information(
    List<List<String>> _info, {
    double? width,
    double? fontSize,
  }) {
    return _info.isEmpty
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < _info.length; i++) ...[
                Builder(builder: (_) {
                  final list = _info[i];
                  return Column(children: [
                    for (int j = 0; j < list.length; j++) ...[
                      Builder(builder: (_) {
                        final item = list[j];
                        final isItemSub = item.contains('SUB');
                        final isListSub = list.any(
                          (element) => element.contains('SUB'),
                        );

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (isItemSub == false)
                              Text(
                                "${isListSub ? j : j + 1}. ",
                                textAlign: TextAlign.start,
                                style: Themes.customColor(fontSize ?? 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            SizedBox(
                              width: width ?? 250,
                              child: Text(
                                isItemSub
                                    ? "\n${item.replaceAll("<SUB>", "")}\n"
                                    : "${item}",
                                textAlign: TextAlign.start,
                                style: Themes.customColor(
                                  fontSize ?? 13,
                                  fontWeight: isItemSub
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(
                        height: 4,
                      )
                    ],
                  ]);
                })
              ]
            ],
          );
  }
}
