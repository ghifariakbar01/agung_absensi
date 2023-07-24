import 'package:face_net_authentication/constants/assets.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/v_button.dart';
import '../../widgets/v_dialogs.dart';

class HomeBottomsheet extends ConsumerWidget {
  const HomeBottomsheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 250,
      width: width,
      padding: EdgeInsets.all(16),
      child: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 8,
            ),

            // instruction 1
            // Container(
            //     height: 126,
            //     width: 90,
            //     decoration: BoxDecoration(
            //         color: Palette.primaryColor,
            //         borderRadius: BorderRadius.circular(16)),
            //     padding: EdgeInsets.all(4),
            //     child: Column(children: [
            //       SizedBox(
            //         height: 4,
            //       ),
            //       Container(
            //           height: 85,
            //           width: 85,
            //           padding: EdgeInsets.all(4),
            //           decoration: BoxDecoration(
            //               color: Colors.grey.withOpacity(0.1),
            //               borderRadius: BorderRadius.circular(16)),
            //           child: Icon(
            //             Icons.light,
            //             size: 75,
            //             color: Colors.white,
            //           )),
            //       SizedBox(
            //         height: 4,
            //       ),
            //       Spacer(),
            //       Text(
            //         '1. Memiliki pencahayaan cukup.',
            //         style: Themes.white(FontWeight.bold, 14),
            //       ),
            //       SizedBox(
            //         height: 4,
            //       ),
            //     ])),
            // SizedBox(
            //   height: 8,
            // ),

            // instruction 2
            Container(
                height: 126,
                width: 90,
                decoration: BoxDecoration(
                    color: Palette.secondaryColor,
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.all(4),
                child: Column(children: [
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                      height: 85,
                      width: 85,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(
                        Icons.radar,
                        size: 75,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 4,
                  ),
                  Spacer(),
                  Text(
                    'Jarak dibawah 100m.',
                    style:
                        Themes.customColor(FontWeight.bold, 14, Colors.white),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ])),

            SizedBox(
              height: 24,
            ),

            // Absen Masuk
            VButton(
                label: 'LANJUTKAN',
                onPressed: () {
                  context.pop();

                  // showDialog(
                  //     context: context,
                  //     builder: (_) => VDialog(
                  //           asset: Assets.iconChecked,
                  //           label: 'JAM 08.00',
                  //           labelDescription: 'BERHASIL',
                  //         ));

                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                            asset: Assets.iconCrossed,
                            label: 'NoConnection',
                            labelDescription: 'Tidak ada internet',
                          ));

                  // context.pushNamed(RouteNames.cameraRoute);
                })
          ],
        ),
      ),
    );
  }
}
