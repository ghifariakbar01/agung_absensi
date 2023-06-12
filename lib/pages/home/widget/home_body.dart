import 'package:face_net_authentication/pages/home/widget/home_bottomsheet.dart';
import 'package:flutter/material.dart';

import '../../../style/style.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Absen Masuk
        TextButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              backgroundColor: Colors.white,
              builder: (BuildContext context) {
                return HomeBottomsheet();
              },
            );
          },
          child: Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Palette.primaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                'ABSEN IN',
                style: Themes.blueSpaced(
                  FontWeight.bold,
                  16,
                ),
              ),
            ),
          ),
        ),

        // Absen Keluar
        TextButton(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              return HomeBottomsheet();
            },
          ),
          child: Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Palette.greyDisabled,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                'ABSEN OUT',
                style: Themes.grey(
                  FontWeight.bold,
                  16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
