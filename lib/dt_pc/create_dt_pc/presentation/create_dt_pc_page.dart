import 'dart:developer';

import 'package:face_net_authentication/dt_pc/dt_pc_list/application/dt_pc_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../shared/providers.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../style/style.dart';
import '../../../user_helper/user_helper_notifier.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/v_button.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../application/create_dt_pc_notifier.dart';

class CreateDtPcPage extends HookConsumerWidget {
  const CreateDtPcPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final ptTextController = useTextEditingController(text: nama.user.payroll);

    final keteranganTextController = useTextEditingController();
    final kategoriTextController = useState('Datang Telat');

    final tglPlaceholderTextController = useTextEditingController();

    final dtTglTextController = useState('');
    final jamTextController = useState('');

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    ref.listen<AsyncValue>(createDtPcNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form DT/PC',
          onDone: () {
            ref.invalidate(dtPcListControllerProvider);
            context.pop();
            return Future.value(true);
          },
        );
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final createIzin = ref.watch(createDtPcNotifierProvider);
    // final jenisIzin = ref.watch(jenisIzinNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createIzin,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryColor,
              scaffoldTitle: 'Create Form DT / PC',
              scaffoldBody: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
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

                      // PT
                      TextFormField(
                          enabled: false,
                          controller: ptTextController,
                          cursorColor: Palette.primaryColor,
                          keyboardType: TextInputType.name,
                          decoration: Themes.formStyleBordered(
                            'PT',
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

                      DropdownButtonFormField<String>(
                        elevation: 0,
                        iconSize: 20,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: Palette.primaryColor),
                        decoration: Themes.formStyleBordered(
                          'Kategori',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Form tidak boleh kosong';
                          }

                          if (value.isEmpty) {
                            return 'Form tidak boleh kosong';
                          }
                          return null;
                        },
                        value: kategoriTextController.value,
                        onChanged: (String? value) {
                          if (value != null) {
                            kategoriTextController.value = value;
                          }
                        },
                        isExpanded: true,
                        items: ['Datang Telat', 'Pulang Cepat']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: Themes.customColor(
                                14,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      // TGL AWAL
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 3)),
                            );
                            if (picked != null) {
                              print(picked);

                              final dtTgl = StringUtils.midnightDate(picked)
                                  .replaceAll('.000', '');

                              dtTglTextController.value = dtTgl;

                              final hour = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              final jam = DateTime(picked.year, picked.month,
                                  picked.day, hour!.hour, hour.minute);

                              final startPlaceHolder = DateFormat(
                                'dd MMM yyyy HH:mm',
                              ).format(jam);

                              log('jam $jam dtTgl $dtTgl ');

                              jamTextController.value =
                                  jam.toString().replaceAll('.000', '');

                              tglPlaceholderTextController.text =
                                  "$startPlaceHolder";
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                cursorColor: Palette.primaryColor,
                                controller: tglPlaceholderTextController,
                                decoration: Themes.formStyleBordered(
                                  'Tanggal & Jam',
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
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      // DIAGNOSA
                      TextFormField(
                          maxLines: 2,
                          controller: keteranganTextController,
                          cursorColor: Palette.primaryColor,
                          decoration: Themes.formStyleBordered(
                            'Keterangan',
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
                        height: 54,
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VButton(
                            label:
                                kategoriTextController.value == 'Datang Telat'
                                    ? 'Apply Datang Telat'
                                    : 'Apply Pulang Cepat',
                            onPressed: () async {
                              final user = ref.read(userNotifierProvider).user;
                              final kategori =
                                  kategoriTextController.value == 'Datang Telat'
                                      ? 'DT'
                                      : 'PC';

                              final _dtTgl = dtTglTextController.value
                                  .replaceAll('00:00:00', '');
                              final _jam = jamTextController.value.substring(
                                  0, jamTextController.value.length - 3);

                              log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                              log(' Payroll: ${ptTextController.value.text} \n ');
                              log(' Keterangan: ${keteranganTextController.value.text} \n ');
                              log(' Kategori DT / PC: ${kategoriTextController.value} \n ');
                              log(' DT Tanggal: ${_dtTgl} \n ');
                              log(' Jam: ${_jam} \n ');

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createDtPcNotifierProvider.notifier)
                                    .submitDtPc(
                                        idUser: user.idUser!,
                                        dtTgl: _dtTgl,
                                        jam: _jam,
                                        kategori: kategori,
                                        ket: keteranganTextController.text,
                                        onError: (msg) =>
                                            DialogHelper.showCustomDialog(
                                              msg,
                                              context,
                                            ));
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
