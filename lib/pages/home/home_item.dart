import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../application/permission/shared/permission_introduction_providers.dart';
import '../../application/routes/route_names.dart';
import '../../style/style.dart';
import '../widgets/v_dialogs.dart';
import 'home_scaffold.dart';

class WelcomeItem extends ConsumerWidget {
  const WelcomeItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        bool isAbsenRoute = item.routeNames == RouteNames.absenRoute;
        bool isLocationOn = await FlLocation.isLocationServicesEnabled;
        bool isLocationDenied = await ref
            .read(permissionNotifierProvider.notifier)
            .isLocationDenied();

        if (isAbsenRoute) {
          if (!isLocationOn) {
            await showDialog(
              context: context,
              builder: (context) => VSimpleDialog(
                  label: 'GPS Tidak Berfungsi',
                  labelDescription:
                      'Mohon nyalakan GPS pada device anda. Terimakasih',
                  asset: 'assets/ic_location_off.svg'),
            );
          } else {
            if (isLocationDenied) {
              await showDialog(
                context: context,
                builder: (context) => VSimpleDialog(
                    label: 'Izin Lokasi Tidak Aktif',
                    labelDescription:
                        'Mohon nyalakan Izin Lokasi untuk E-FINGER. Terimakasih',
                    asset: 'assets/ic_location_off.svg'),
              ).then((_) => openAppSettings);
            } else {
              await context.pushNamed(item.routeNames);
            }
          }
        } else {
          await context.pushNamed(item.routeNames);
        }
      },
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
                    color: Colors.white),
                padding: EdgeInsets.all(8),
                child: SizedBox(
                    child: SvgPicture.asset(
                  item.icon,
                  color: Palette.primaryLighter,
                ))),
            Text(
              item.absen.toUpperCase(),
              style: Themes.customColor(FontWeight.bold, 9, Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
