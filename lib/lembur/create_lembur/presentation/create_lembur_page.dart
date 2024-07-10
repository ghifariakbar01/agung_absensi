// ignore_for_file: sdk_version_since

import 'dart:developer';

import 'package:face_net_authentication/lembur/lembur_list/application/lembur_list_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_button.dart';

import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../style/style.dart';
import '../application/create_lembur_notifier.dart';
import '../application/jenis_lembur.dart';

class CreateLemburPage extends HookConsumerWidget {
  const CreateLemburPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final jenisLemburTextController = useState('');

    final keteranganLemburTextController = useTextEditingController();

    final tglStartPlaceholder = useTextEditingController();
    final tglStart = useState(DateTime.now());

    final tglEndPlaceholder = useTextEditingController();
    final tglEnd = useState(DateTime.now().add(Duration(days: 1)));

    final createLembur = ref.watch(createLemburNotifierProvider);
    final jenisLembur = ref.watch(jenisLemburNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    ref.listen<AsyncValue>(createLemburNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          onDone: () async {
            ref.invalidate(lemburListControllerProvider);
            context.pop();
          },
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form Lembur ',
        );
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createLembur,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryColor,
              scaffoldTitle: 'Create Form Lembur',
              scaffoldBody: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    children: [
                      // NAMA
                      TextFormField(
                          enabled: false,
                          controller: namaTextController,
                          cursorColor: Palette.primaryColor,
                          keyboardType: TextInputType.name,
                          decoration: Themes.formStyleBordered(
                            'Masukkan nama',
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

                      // Jenis Lembur
                      VAsyncValueWidget<List<JenisLembur>>(
                        value: jenisLembur,
                        data: (list) => DropdownButtonFormField<JenisLembur>(
                          elevation: 0,
                          iconSize: 20,
                          padding: EdgeInsets.all(0),
                          icon: const Icon(Icons.arrow_downward),
                          decoration: Themes.formStyleBordered('Jenis Lembur'),
                          validator: (value) {
                            if (value == null) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          },
                          onChanged: (JenisLembur? value) {
                            if (value != null) {
                              jenisLemburTextController.value = value.Kode!;
                            }
                          },
                          items: list.map<DropdownMenuItem<JenisLembur>>(
                              (JenisLembur value) {
                            return DropdownMenuItem<JenisLembur>(
                              value: value,
                              child: Text(
                                value.Nama!,
                                style: Themes.customColor(
                                  14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      // TANGGAL LEMBUR AWAL
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final _oneYear = Duration(days: 365);

                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(_oneYear),
                              lastDate: DateTime.now().add(_oneYear),
                            );

                            if (picked != null) {
                              final _hour = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(picked),
                              );

                              if (_hour != null) {
                                tglStart.value = picked.copyWith(
                                  hour: _hour.hour,
                                  minute: _hour.minute,
                                );

                                tglStartPlaceholder.text = DateFormat(
                                  'E, dd MMM yyyy HH:mm',
                                ).format(tglStart.value);
                              }
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                cursorColor: Palette.primaryColor,
                                controller: tglStartPlaceholder,
                                decoration: Themes.formStyleBordered(
                                  'Tanggal Lembur Awal',
                                  icon: Icon(Icons.calendar_month),
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

                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final _oneYear = Duration(days: 365);

                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(_oneYear),
                              lastDate: DateTime.now().add(_oneYear),
                            );

                            if (picked != null) {
                              final _hour = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(picked),
                              );

                              if (_hour != null) {
                                tglEnd.value = picked.copyWith(
                                  hour: _hour.hour,
                                  minute: _hour.minute,
                                );

                                tglEndPlaceholder.text = DateFormat(
                                  'E, dd MMM yyyy HH:mm',
                                ).format(tglEnd.value);
                              }
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                cursorColor: Palette.primaryColor,
                                controller: tglEndPlaceholder,
                                decoration: Themes.formStyleBordered(
                                  'Tanggal Lembur Akhir',
                                  icon: Icon(Icons.calendar_month),
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

                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextFormField(
                            controller: keteranganLemburTextController,
                            cursorColor: Palette.primaryColor,
                            keyboardType: TextInputType.name,
                            decoration: Themes.formStyleBordered(
                              'Masukkan keterangan',
                            ),
                            style: Themes.customColor(
                              14,
                              fontWeight: FontWeight.normal,
                            ),
                            validator: (item) {
                              if (item == null) {
                                return 'Form tidak boleh kosong';
                              } else if (item.length < 10) {
                                return 'Keterangan Harus Diisi Minimal 10 Karakter!';
                              } else if (item.isEmpty) {
                                return 'Form tidak boleh kosong';
                              }

                              return null;
                            }),
                      ),

                      Container(
                        height: 60,
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VButton(
                            label: 'Apply Lembur',
                            onPressed: () async {
                              log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                              log(' Jenis Lembur: ${jenisLemburTextController.value} \n ');
                              log(' Keterangan: ${keteranganLemburTextController.text} \n ');
                              log(' Tgl Start PlaceHolder: ${tglStartPlaceholder.text} \n ');
                              log(' Tgl End PlaceHolder: ${tglEndPlaceholder.text} \n ');
                              log(' Tgl Start: ${tglStart.value} \n ');
                              log(' Tgl End: ${tglEnd.value} \n ');

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createLemburNotifierProvider.notifier)
                                    .submitLembur(
                                      tgl: tglStart.value,
                                      jamAkhir: tglEnd.value,
                                      jamAwal: tglStart.value,
                                      keterangan:
                                          keteranganLemburTextController.text,
                                      kategori: jenisLemburTextController.value,
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
