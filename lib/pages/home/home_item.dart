// ignore_for_file: deprecated_member_use

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';
import 'home_scaffold.dart';

class HomeItem extends ConsumerWidget {
  const HomeItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => ref.read(homeNotifierProvider.notifier).redirect(
            ref: ref,
            context: context,
            route: item.routeNames,
          ),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Palette.primaryLighter,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColorLight),
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    child: SvgPicture.asset(
                  item.icon,
                  color: Palette.primaryLighter,
                ))),
            SizedBox(
              height: 4,
            ),
            Text(
              item.absen.toUpperCase(),
              style: Themes.customColor(
                FontWeight.bold,
                9,
              ),
            )
          ],
        ),
      ),
    );
  }
}
