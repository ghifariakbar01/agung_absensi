import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../style/style.dart';
import '../utils/logging.dart';

final progressProvider = StateProvider<int>((ref) {
  return 0;
});

enum FileSource {
  camera,
  gallery,
  file,
}

class WebViewCustom extends StatefulHookConsumerWidget {
  const WebViewCustom(this.imageUrl, {Key? key}) : super(key: key);

  final String imageUrl;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewCustomState();
}

class _WebViewCustomState extends ConsumerState<WebViewCustom> {
  late WebViewController controller;

  _onProgress(int prog) {
    ref.read(progressProvider.notifier).state = prog;
  }

  @override
  void initState() {
    super.initState();

    if (context.mounted) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (prog) {
              _onProgress(prog);
              Log.info('prog $prog progress ${ref.read(progressProvider)}');
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.imageUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.mounted == false) {
      return Container();
    } else {
      final progress = ref.watch(progressProvider);

      Future<List<String>> _androidFilePicker(
          final BuildContext context) async {
        final ImagePicker picker = ImagePicker();

        // Show dialog to choose option
        final result = await showDialog<FileSource>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Select Option"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Camera"),
                    onTap: () {
                      Navigator.pop(context, FileSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Photo Library"),
                    onTap: () {
                      Navigator.pop(context, FileSource.gallery);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_file),
                    title: Text("File"),
                    onTap: () {
                      Navigator.pop(context, FileSource.file);
                    },
                  ),
                ],
              ),
            );
          },
        );

        if (result == null) return [];

        switch (result) {
          case FileSource.camera:
            final XFile? image =
                await picker.pickImage(source: ImageSource.camera);
            if (image != null && image.path.isNotEmpty) {
              return [File(image.path).uri.toString()];
            }
            break;

          case FileSource.gallery:
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
            if (image != null && image.path.isNotEmpty) {
              return [File(image.path).uri.toString()];
            }
            break;

          case FileSource.file:
            final fileResult = await FilePicker.platform.pickFiles();
            if (fileResult != null && fileResult.files.single.path != null) {
              return [File(fileResult.files.single.path!).uri.toString()];
            }
            break;
        }

        return [];
      }

      useEffect(() {
        Platform.isAndroid
            ? (controller.platform as AndroidWebViewController)
                .setOnShowFileSelector(
                (_) => _androidFilePicker(context),
              )
            : () {};
        return () {};
      }, [controller]);

      return Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (progress > 0 && progress < 100)
            Align(
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${progress} %',
                      style: Themes.customColor(
                        14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
        ],
      );
    }
  }
}
