import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/assets.dart';
import '../../../err_log/application/err_log_notifier.dart';
import '../../../../utils/dialog_helper.dart';
import '../../../../widgets/tappable_widget.dart';
import '../../../../widgets/v_async_widget.dart';

import '../../create_jadwal_shift/application/create_jadwal_shift_notifier.dart';
import '../application/jadwal_detail_notifier.dart';
import '../application/jadwal_shift_detail.dart';
import 'jadwal_shift_detail_list.dart';

class JadwalShiftDtlDialog extends ConsumerStatefulWidget {
  const JadwalShiftDtlDialog(this.id, this.isDelete, {Key? key})
      : super(key: key);

  final int id;
  final bool isDelete;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JadwalShiftDtlDialogState();
}

class _JadwalShiftDtlDialogState extends ConsumerState<JadwalShiftDtlDialog> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => ref
        .read(jadwalDetailControllerProvider.notifier)
        .loadDetail(idShift: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final jadwalShiftDetail = ref.watch(jadwalDetailControllerProvider);
    final isDelete = widget.isDelete;

    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(36),
          child: Stack(
            children: [
              VAsyncValueWidget<List<JadwalShiftDetail>>(
                value: jadwalShiftDetail,
                data: (list) {
                  return JadwalShiftDetailList(
                    setState,
                    list: list,
                  );
                },
              ),
              if (isDelete)
                Positioned(
                    bottom: 5,
                    right: 5,
                    child: TappableSvg(
                        assetPath: Assets.iconDelete,
                        onTap: () async {
                          final result =
                              await DialogHelper.showConfirmationDialog(
                            context: context,
                            label: 'Hapus jadwal shift ? ',
                          );

                          if (result == true) {
                            await ref
                                .read(createJadwalShiftProvider.notifier)
                                .deleteJadwalShift(
                                    idShift: widget.id,
                                    onError: (msg) {
                                      return DialogHelper.showCustomDialog(
                                        msg,
                                        context,
                                      ).then((_) => ref
                                          .read(
                                              errLogControllerProvider.notifier)
                                          .sendLog(errMessage: msg));
                                    });
                          }
                        })),
            ],
          ),
        );
      },
    );
  }
}
