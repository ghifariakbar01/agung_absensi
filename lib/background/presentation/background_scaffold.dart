import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import 'widget/background_item.dart';

class BackgroundScaffold extends ConsumerWidget {
  const BackgroundScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundItems = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          title: Text(
            'Absen Tersimpan',
            style: Themes.customColor(
              20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
            child: ListView.builder(
                itemCount: backgroundItems.length,
                itemBuilder: ((context, index) => BackgroundItem(
                      item: backgroundItems[index],
                      index: index,
                    )))));
  }
}
