import 'package:face_net_authentication/utils/logging.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../ganti_hari/ganti_hari_list/application/ganti_hari_list_notifier.dart';
import '../../../../shared/providers.dart';
import '../../../../utils/dialog_helper.dart';
import '../../../../widgets/alert_helper.dart';
import '../../../../widgets/v_async_widget.dart';
import '../../../../style/style.dart';
import '../../../../widgets/v_button.dart';
import '../../../../widgets/v_scaffold_widget.dart';
import '../application/create_jadwal_shift_notifier.dart';

class CreateJadwalShiftPage extends HookConsumerWidget {
  const CreateJadwalShiftPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);

    final periode = useState(DateTime.now().subtract(Duration(days: 1)));
    final periodePlaceHolder = useTextEditingController();

    final week = useState(1);
    final weekList = [1, 2];

    ref.listen<AsyncValue>(createJadwalShiftProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form Jadwal Shift',
          onDone: () {
            ref.invalidate(gantiHariListControllerProvider);
            context.pop();
            return Future.value(true);
          },
        );
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final createJadwal = ref.watch(createJadwalShiftProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createJadwal,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryColor,
              scaffoldTitle: 'Create Form Jadwal Shift',
              scaffoldBody: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 8,
                      ),

                      // NAMA
                      TextFormField(
                          enabled: false,
                          controller: namaTextController,
                          keyboardType: TextInputType.name,
                          cursorColor: Palette.primaryColor,
                          decoration: Themes.formStyleBordered(
                            'Nama',
                          ),
                          style: Themes.customColor(
                            14,
                            fontWeight: FontWeight.normal,
                          ),
                          validator: (item) {
                            if (item == null) {
                              return 'Form tidak boleh kosong';
                            } else if (item.isEmpty) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          }),

                      SizedBox(
                        height: 16,
                      ),

                      // PERIODE
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showMonthPicker(
                                context: context,
                                initialDate: DateTime.now(),
                                monthPickerDialogSettings:
                                    MonthPickerDialogSettings(
                                        headerSettings: PickerHeaderSettings(
                                            headerBackgroundColor:
                                                Palette.primaryColor)));

                            if (picked == null) {
                              return;
                            }

                            periode.value = picked;

                            periodePlaceHolder.text = DateFormat(
                              'yyyy-MMMM',
                            ).format(periode.value);
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                controller: periodePlaceHolder,
                                cursorColor: Palette.primaryColor,
                                decoration: Themes.formStyleBordered('Periode',
                                    icon: Icon(
                                      Icons.calendar_month,
                                    )),
                                style: Themes.customColor(
                                  14,
                                  fontWeight: FontWeight.normal,
                                ),
                                validator: (item) {
                                  if (item == null) {
                                    return 'Form tidak boleh kosong';
                                  } else if (item.isEmpty) {
                                    return 'Form tidak boleh kosong';
                                  }

                                  return null;
                                }),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      DropdownButtonFormField<int>(
                        isExpanded: true,
                        elevation: 0,
                        iconSize: 20,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: Palette.primaryColor),
                        decoration: Themes.formStyleBordered(
                          'Minggu ke-',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Form tidak boleh kosong';
                          }

                          return null;
                        },
                        value: weekList.firstWhere(
                          (element) => element == week.value,
                          orElse: () => weekList.first,
                        ),
                        onChanged: (int? value) {
                          if (value != null) {
                            week.value = value;
                          }
                        },
                        items: weekList.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              'Week ${value} & ${value + 1}',
                              style: Themes.customColor(
                                14,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(
                        height: 8,
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VButton(
                            label: 'Submit Jadwal Shift',
                            onPressed: () async {
                              Log.info(
                                  ' VARIABLES : \n  Nama : ${namaTextController.value.text} '
                                  ' \n periode ${periode.value} '
                                  ' \n week ${week.value} ');

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createJadwalShiftProvider.notifier)
                                    .submitJadwalShift(
                                      dateTime: periode.value,
                                      week: week.value,
                                      onError: (msg) {
                                        return DialogHelper.showCustomDialog(
                                          msg,
                                          context,
                                        ).then((_) => ref
                                            .read(errLogControllerProvider
                                                .notifier)
                                            .sendLog(errMessage: msg));
                                      },
                                    );
                              }
                            }),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
