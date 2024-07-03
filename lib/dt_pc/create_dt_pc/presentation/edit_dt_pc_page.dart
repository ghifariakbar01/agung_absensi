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

import '../../../widgets/v_button.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../dt_pc_list/application/dt_pc_list.dart';
import '../application/create_dt_pc_notifier.dart';

String _returnPlaceHolderText(
  DateTime hour,
) {
  final startPlaceHolder = DateFormat(
    'dd MMM yyyy HH:mm',
  ).format(hour);

  return "$startPlaceHolder";
}

class EditDtPcPage extends HookConsumerWidget {
  const EditDtPcPage(this.item);

  final DtPcList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);

    final keteranganTextController = useTextEditingController(text: item.ket);
    final kategoriTextController = useState(
      item.kategori!.toLowerCase() == 'dt' ? 'Datang Telat' : 'Pulang Cepat',
    );

    final tglPlaceholderTextController =
        useTextEditingController(text: _returnPlaceHolderText(item.jam!));

    final dtTgl = useState(item.dtTgl!);
    final jamText = useState(item.jam!);

    final noteSpvTextController = useTextEditingController(text: item.spvNote);
    final noteHrdTextController = useTextEditingController(text: item.hrdNote);

    ref.listen<AsyncValue>(createDtPcNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: 'Sukses Edit Form Dt / Pc',
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
              scaffoldTitle: 'Edit Form DT / PC',
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
                            final _oneYear = Duration(days: 365);

                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now().add(_oneYear),
                              firstDate: DateTime.now().subtract(_oneYear),
                            );

                            if (picked != null) {
                              print(picked);

                              dtTgl.value = picked;

                              final hour = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              final jam = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                hour!.hour,
                                hour.minute,
                              );

                              final startPlaceHolder = DateFormat(
                                'dd MMM yyyy HH:mm',
                              ).format(jam);

                              log('jam $jam dtTgl $picked ');

                              jamText.value = jam;

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
                        height: 16,
                      ),
                      TextFormField(
                          controller: noteSpvTextController,
                          cursorColor: Palette.primaryColor,
                          decoration: Themes.formStyleBordered(
                            'Note SPV',
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
                      TextFormField(
                          controller: noteHrdTextController,
                          cursorColor: Palette.primaryColor,
                          decoration: Themes.formStyleBordered(
                            'Note HRD',
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
                              final kategori =
                                  kategoriTextController.value == 'Datang Telat'
                                      ? 'DT'
                                      : 'PC';
                              final _dtTgl =
                                  DateFormat('yyyy-MM-dd').format(dtTgl.value);
                              final _jamText = DateFormat('yyyy-MM-dd HH:mm')
                                  .format(jamText.value);

                              log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');

                              log(' Keterangan: ${keteranganTextController.value.text} \n ');
                              log(' Jenis DT/PC: $kategori \n ');
                              log(' Dt Tgl: $_dtTgl \n ');
                              log(' Jam Text: $_jamText \n ');
                              log(' Note Spv: ${noteSpvTextController.text} \n ');
                              log(' Note Hrd: ${noteHrdTextController.text} \n ');

                              final user = ref.read(userNotifierProvider).user;

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createDtPcNotifierProvider.notifier)
                                    .updateDtPc(
                                        id: item.idDt!,
                                        idUser: user.idUser!,
                                        dtTgl: _dtTgl,
                                        jam: _jamText,
                                        kategori: kategori,
                                        noteSpv: noteSpvTextController.text,
                                        noteHrd: noteHrdTextController.text,
                                        ket: keteranganTextController.text
                                            .replaceAll("\n", " "),
                                        onError: (msg) {
                                          return DialogHelper.showCustomDialog(
                                            msg,
                                            context,
                                          ).then((_) => ref
                                              .read(errLogControllerProvider
                                                  .notifier)
                                              .sendLog(errMessage: msg));
                                        });
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
