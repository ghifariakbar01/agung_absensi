import 'package:face_net_authentication/jadwal_shift/jadwal_shift_list/application/jadwal_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/v_button.dart';
import '../../create_jadwal_shift/application/create_jadwal_shift_notifier.dart';
import '../application/jadwal_shift_detail.dart';
import 'jadwal_shift_dtl_item.dart';

class JadwalShiftDetailList extends HookConsumerWidget {
  const JadwalShiftDetailList(this.setState, {Key? key, required this.list});

  final List<JadwalShiftDetail> list;
  final Function(void Function()) setState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChanging = useState(false);
    final listParam = useState([JadwalShiftDetailParam.initial()]);

    final Function() checkIsChanging = () {
      final cond = listParam.value
          .where((e) => e != JadwalShiftDetailParam.initial())
          .isNotEmpty;

      isChanging.value = cond;
    };

    final Function(JadwalShiftDetail item) addToParam = (item) {
      final jdw = JadwalShiftDetailParam(
        idShift: item.idShiftDtl!,
        jadwal: item.jadwal!,
      );

      listParam.value.add(jdw);
    };

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    return list.isEmpty
        ? Container()
        : Form(
            key: _formKey,
            child: ListView.separated(
              itemCount: list.length,
              itemBuilder: (_, index) {
                final item = list[index];
                final isLast = index + 1 == list.length;

                return isLast
                    ? isChanging.value
                        ? Column(
                            children: [
                              JadwalShiftDtlItem(
                                  item: item,
                                  onChanged: (itm) {
                                    ref
                                        .read(jadwalDetailControllerProvider
                                            .notifier)
                                        .modify(
                                          checkIsChanging,
                                          addToParam,
                                          idx: index,
                                          item: itm,
                                        );

                                    setState(() {});
                                  }),
                              SizedBox(
                                height: 8,
                              ),
                              VButton(
                                  label: 'Submit',
                                  height: 45,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  onPressed: () async {
                                    //
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      await ref
                                          .read(createJadwalShiftProvider
                                              .notifier)
                                          .updateJadwalShift(
                                              listParam: listParam.value,
                                              onError: (msg) {
                                                return DialogHelper
                                                    .showCustomDialog(
                                                  msg,
                                                  context,
                                                ).then((_) => ref
                                                    .read(
                                                        errLogControllerProvider
                                                            .notifier)
                                                    .sendLog(errMessage: msg));
                                              });
                                    }
                                  }),
                            ],
                          )
                        : JadwalShiftDtlItem(
                            item: item,
                            onChanged: (itm) {
                              ref
                                  .read(jadwalDetailControllerProvider.notifier)
                                  .modify(
                                    checkIsChanging,
                                    addToParam,
                                    idx: index,
                                    item: itm,
                                  );

                              setState(() {});
                            })
                    : JadwalShiftDtlItem(
                        item: item,
                        onChanged: (itm) {
                          ref
                              .read(jadwalDetailControllerProvider.notifier)
                              .modify(
                                checkIsChanging,
                                addToParam,
                                idx: index,
                                item: itm,
                              );

                          setState(() {});
                        });
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 8,
              ),
            ),
          );
  }
}
