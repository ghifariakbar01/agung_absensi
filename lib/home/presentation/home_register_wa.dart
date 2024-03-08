import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../style/style.dart';
import '../../wa_register/application/wa_register_notifier.dart';

class HomeRegisterWa extends ConsumerWidget {
  const HomeRegisterWa();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 68,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => SizedBox(
          width: 8,
        ),
        itemBuilder: (__, _) => Ink(
            height: 68,
            width: 68,
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
              onTap: () => ref
                  .read(waRegisterNotifierProvider.notifier)
                  .confirmRegisterWa(context: context),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  children: [
                    SvgPicture.asset(Assets.iconWa),
                    Expanded(child: Container()),
                    Text(
                      'Register Wa ',
                      style: Themes.customColor(
                        7,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ),
            )),
        itemCount: 1,
      ),
    );
  }
}

class HomeRetryRegisterWa extends ConsumerWidget {
  const HomeRetryRegisterWa();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 68,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => SizedBox(
          width: 8,
        ),
        itemBuilder: (__, _) => Ink(
            height: 68,
            width: 68,
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
              onTap: () => ref
                  .read(waRegisterNotifierProvider.notifier)
                  .retryRegisterWa(context: context),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  children: [
                    SvgPicture.asset(Assets.iconWaReregist),
                    Spacer(),
                    Text(
                      'Ulangi Register Wa ',
                      style: Themes.customColor(
                        6,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ),
            )),
        itemCount: 1,
      ),
    );
  }
}
