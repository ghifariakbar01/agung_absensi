import 'package:face_net_authentication/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/providers.dart';
import '../../../style/style.dart';

class RiwayatHeader extends ConsumerWidget {
  const RiwayatHeader({required this.date});

  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Ink(
            height: 45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Palette.primaryColor,
            ),
            child: InkWell(
              onTap: () async {
                final _oneYear = Duration(days: 365);

                final picked = await showDateRangePicker(
                  context: context,
                  lastDate: DateTime.now().add(_oneYear),
                  firstDate: DateTime.now().subtract(_oneYear),
                );

                if (picked != null) {
                  final _start = picked.start;
                  final _end = picked.end.add(Duration(days: 1));

                  final _start2 = StringUtils.yyyyMMddWithStripe(_start);
                  final _end2 = StringUtils.yyyyMMddWithStripe(_end);

                  await ref
                      .read(riwayatAbsenNotifierProvider.notifier)
                      .startFilter(
                        changeFilter: () => ref
                            .read(riwayatAbsenNotifierProvider.notifier)
                            .changeFilter(
                              _end2,
                              _start2,
                            ),
                        onAllChanged: () => ref
                            .read(riwayatAbsenNotifierProvider.notifier)
                            .filterRiwayatAbsen(
                              dateFirst: _end2,
                              dateSecond: _start2,
                            ),
                      );
                }
              },
              child: Center(
                child: Text(
                  date,
                  style: Themes.customColor(15,
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Flexible(
          flex: 0,
          child: Ink(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.primaryColor),
            child: InkWell(
              onTap: () async {
                final _oneYear = Duration(days: 365);

                final picked = await showDateRangePicker(
                  context: context,
                  lastDate: DateTime.now().add(_oneYear),
                  firstDate: DateTime.now().subtract(_oneYear),
                );

                if (picked != null) {
                  print(picked);

                  final _start = picked.start;
                  final _end = picked.end.add(Duration(days: 1));

                  final _start2 = StringUtils.yyyyMMddWithStripe(_start);
                  final _end2 = StringUtils.yyyyMMddWithStripe(_end);

                  await ref
                      .read(riwayatAbsenNotifierProvider.notifier)
                      .startFilter(
                        changeFilter: () => ref
                            .read(riwayatAbsenNotifierProvider.notifier)
                            .changeFilter(
                              _end2,
                              _start2,
                            ),
                        onAllChanged: () => ref
                            .read(riwayatAbsenNotifierProvider.notifier)
                            .filterRiwayatAbsen(
                              dateFirst: _end2,
                              dateSecond: _start2,
                            ),
                      );
                }
              },
              child: Icon(
                Icons.filter_alt_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
