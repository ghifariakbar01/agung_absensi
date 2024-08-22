// ignore_for_file: deprecated_member_use

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';
import 'home_scaffold.dart';

class HomeItem extends ConsumerWidget {
  const HomeItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Ink(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(-1, 1), // Controls the position of the shadow
            ),
          ],
        ),
        child: InkWell(
          onTap: () => ref.read(homeNotifierProvider.notifier).redirect(
                ref: ref,
                context: context,
                route: item.routeNames,
              ),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Column(
              children: [
                SvgPicture.asset(item.asset),
                Spacer(),
                Text(
                  item.name,
                  style: Themes.customColor(
                    8,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
