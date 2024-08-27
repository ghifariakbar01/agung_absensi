import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../style/style.dart';

import '../infrastructures/image/infrastructures/image_repository.dart';
import '../utils/logging.dart';

final displayImageProvider = StateProvider<bool>((ref) {
  return false;
});

final imageErrorProvider = StateProvider<bool>((ref) {
  return false;
});

extension WebViewControllerExtension on WebViewController {
  Future<String> getHtml(BuildContext context) {
    if (context.mounted) {
      return runJavaScriptReturningResult('document.documentElement.outerHTML')
          .then((value) {
        if (Platform.isAndroid) {
          return jsonDecode(value as String) as String;
        } else {
          return value as String;
        }
      });
    } else {
      return Future.value('');
    }
  }
}

class ImageAbsen extends StatefulHookConsumerWidget {
  const ImageAbsen({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final Uri imageUrl;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageAbsenState();
}

class _ImageAbsenState extends ConsumerState<ImageAbsen> {
  late WebViewController controller;
  late WebViewController controllerDummy;

  @override
  void initState() {
    super.initState();

    final Uri imageUri = widget.imageUrl;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(imageUri);

    controllerDummy = (WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setOnConsoleMessage((c) {
        Log.info('console $c');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {
            ref.read(imageErrorProvider.notifier).state = true;
          },
        ),
      )
      ..loadRequest(imageUri));
  }

  @override
  Widget build(BuildContext context) {
    if (context.mounted == false) {
      return Container();
    } else {
      final imageUrl = ref.watch(imageUrlProvider);
      final imageError = ref.watch(imageErrorProvider);
      final displayImage = ref.watch(displayImageProvider);

      useEffect(() {
        if (context.mounted) {
          controllerDummy
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageFinished: (_) => _check(),
                onHttpError: (_) => _isCurrentlyError(),
                onWebResourceError: (_) => _isCurrentlyError(),
              ),
            );
          return () {};
        }
        return () {};
      }, []);

      return context.mounted == false
          ? Container()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              height: displayImage
                  ? 425
                  : imageError == false
                      ? 50
                      : 1,
              child: Stack(
                children: [
                  // Dummy Webview to validate url
                  SizedBox(
                    height: 1,
                    width: 1,
                    child: WebViewWidget(controller: controllerDummy),
                  ),
                  if (imageUrl.isNotEmpty && imageError == false)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        InkWell(
                          onTap: () => displayImage
                              ? ref.read(displayImageProvider.notifier).state =
                                  false
                              : ref.read(displayImageProvider.notifier).state =
                                  true,
                          child: Ink(
                            child: Row(
                              children: [
                                Text(
                                  'Lokasi Jarak Terdekat',
                                  style: Themes.customColor(
                                    13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' : ',
                                  style: Themes.customColor(
                                    13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                displayImage
                                    ? Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      )
                                    : Icon(Icons.arrow_right_outlined,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor)
                              ],
                            ),
                          ),
                        ),
                        if (displayImage) ...[
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Container(
                                height: 350,
                                width: 300,
                                decoration: BoxDecoration(),
                                padding: EdgeInsets.all(8),
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: WebViewWidget(controller: controller),
                                )),
                          )
                        ]
                      ],
                    ),
                ],
              ));
    }
  }

  _check() async {
    final html = await controllerDummy.getHtml(context);
    if (html.contains('Runtime Error')) {
      _isCurrentlyError();
    }
  }

  _isCurrentlyError() {
    ref.read(imageErrorProvider.notifier).state = true;
  }
}
