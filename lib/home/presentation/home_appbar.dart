import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../routes/application/route_names.dart';
import '../../style/style.dart';
import '../../widgets/network_widget.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeAsync = ref.watch(themeNotifierProvider);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 45,
      actions: [
        SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () => context.pushNamed(RouteNames.copyrightNameRoute),
          child: Icon(
            Icons.copyright,
            color: Palette.tertiaryColor,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        // VAsyncWidgetScaffold<String>(
        //     value: themeAsync,
        //     data: (theme) => InkWell(
        //         onTap: () => ref
        //             .read(themeControllerProvider.notifier)
        //             .saveTheme(
        //                 theme == 'dark' || theme == '' ? 'light' : 'dark'),
        //         child: theme == 'dark'
        //             ? Icon(
        //                 Icons.dark_mode,
        //                 color: Palette.tertiaryColor,
        //               )
        //             : Icon(Icons.dark_mode_outlined,
        //                 color: Palette.tertiaryColor))),
        Expanded(child: Container()),
        SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: () async {
            await ref
                .read(imeiIntroNotifierProvider.notifier)
                .clearVisitedIMEIIntroduction();

            await ref
                .read(imeiIntroNotifierProvider.notifier)
                .checkAndUpdateImeiIntro();
          },
          child: Ink(
            child: Icon(
              Icons.help_outline_outlined,
              color: Palette.tertiaryColor,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () => context.pushNamed(RouteNames.profileNameRoute),
          child: Ink(
            child: Icon(
              Icons.person,
              color: Palette.tertiaryColor,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        NetworkWidget(),
        SizedBox(
          width: 8,
        )
      ],
    );
  }

  static final _appBar = AppBar();
  @override
  Size get preferredSize => _appBar.preferredSize;
}
