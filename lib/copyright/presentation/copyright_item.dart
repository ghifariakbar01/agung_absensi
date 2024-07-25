import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';
import '../../widgets/copyright_text.dart';
import 'copyright_page.dart';

class CopyrightItem extends ConsumerWidget {
  const CopyrightItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);

    return Column(
      children: [
        Center(child: CopyrightAgung()),
        Center(
          child: SelectableText(
            'APP VERSION: ${packageInfo.when(
              loading: () => '',
              data: (packageInfo) => packageInfo,
              error: (error, stackTrace) =>
                  'Error: $error StackTrace: $stackTrace',
            )}',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Themes.customColor(
              8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
