import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/assets.dart';
import '../shared/providers.dart';

class VAlertDialog extends ConsumerWidget {
  const VAlertDialog({
    Key? key,
    this.isLoading = false,
    required this.label,
    required this.labelDescription,
    required this.onPressed,
    this.onBackPressed,
    this.backPressedLabel,
    this.pressedLabel,
  }) : super(key: key);

  final bool isLoading;

  final String label;
  final String labelDescription;
  final String? backPressedLabel;
  final String? pressedLabel;

  final Function() onPressed;
  final Function()? onBackPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(
        absenAuthNotifierProvidier.select((value) => value.isSubmitting));

    return Center(
      child: AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        alignment: Alignment.center,
        actionsAlignment: MainAxisAlignment.spaceAround,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          label,
          style: Themes.customColor(
            20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          labelDescription,
          style: Themes.customColor(
            15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (isLoading) ...[
            Center(
              child: SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(),
              ),
            )
          ],
          if (!isLoading) ...[
            InkWell(
              onTap: onBackPressed ?? () => context.pop(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  backPressedLabel ?? 'TIDAK',
                  style: Themes.customColor(
                    15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  pressedLabel ?? 'YA',
                  style: Themes.customColor(
                    15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class VSimpleDialog extends StatelessWidget {
  const VSimpleDialog({
    Key? key,
    required this.label,
    required this.labelDescription,
    required this.asset,
    this.color,
  }) : super(key: key);

  final Color? color;
  final String asset;
  final String label;
  final String labelDescription;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SimpleDialog(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        title: SizedBox(height: 28, child: SvgPicture.asset(asset)),
        children: [
          SizedBox(
            height: 4,
          ),
          Center(
            child: Text(
              label,
              style: Themes.customColor(
                20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                labelDescription,
                style: Themes.customColor(
                  15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VBatalDialog extends StatelessWidget {
  const VBatalDialog({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          height: 150,
          child: Stack(
            children: [
              Container(
                height: 124,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    'Apa anda ingin membatalkan Pengajuan ini?',
                    textAlign: TextAlign.center,
                    style: Themes.customColor(14),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Ink(
                  height: 31,
                  decoration: BoxDecoration(
                    color: Palette.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: InkWell(
                    onTap: onTap,
                    child: Center(
                      child: Text(
                        'Batalkan',
                        style: Themes.customColor(14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VAksesDitolak extends StatelessWidget {
  const VAksesDitolak({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Palette.red2,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.iconCrossed,
                color: Colors.white,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Anda tidak memiliki akses untuk Approval',
                textAlign: TextAlign.center,
                style: Themes.customColor(14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
