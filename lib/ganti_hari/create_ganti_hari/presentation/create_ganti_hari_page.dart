import 'dart:developer';

import 'package:face_net_authentication/ganti_hari/ganti_hari_list/application/ganti_hari_list_notifier.dart';
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
import '../../../utils/string_utils.dart';
import '../../../widgets/v_button.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../application/absen_ganti_hari.dart';
import '../application/create_ganti_hari_notifier.dart';

class CreateGantiHariPage extends HookConsumerWidget {
  const CreateGantiHariPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);

    final idAbsenGantiHariTextController = useTextEditingController(text: '1');

    final tglOff = useState(DateTime.now().subtract(Duration(days: 1)));
    final tglOffPlaceHolder = useTextEditingController();

    final tglGanti = useState(DateTime.now());
    final tglGantiPlaceHolder = useTextEditingController();

    final keteranganTextController = useTextEditingController();

    ref.listen<AsyncValue>(createGantiHariProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form Ganti Hari',
          onDone: () {
            ref.invalidate(gantiHariListControllerProvider);
            context.pop();
            return Future.value(true);
          },
        );
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final createIzin = ref.watch(createGantiHariProvider);

    final absenGantiHari = ref.watch(absenGantiHariNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createIzin,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryColor,
              scaffoldTitle: 'Create Form Ganti Hari',
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
                      VAsyncValueWidget<List<AbsenGantiHari>>(
                        value: absenGantiHari,
                        data: (absen) =>
                            DropdownButtonFormField<AbsenGantiHari>(
                          isExpanded: true,
                          elevation: 0,
                          iconSize: 20,
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Palette.primaryColor),
                          decoration: Themes.formStyleBordered(
                            'Jadwal Ganti',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          },
                          value: absen.firstWhere(
                            (element) =>
                                element.idAbsen.toString() ==
                                idAbsenGantiHariTextController.text,
                            orElse: () => absen.first,
                          ),
                          onChanged: (AbsenGantiHari? value) {
                            if (value != null) {
                              idAbsenGantiHariTextController.text =
                                  value.idAbsen.toString();
                            }
                          },
                          items: absen.map<DropdownMenuItem<AbsenGantiHari>>(
                              (AbsenGantiHari value) {
                            return DropdownMenuItem<AbsenGantiHari>(
                              value: value,
                              child: Text(
                                '${value.nama} | ${value.jdwIn} | ${value.jdwOut}',
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

                      // TGL OFF
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

                            if (picked == null) {
                              return;
                            }

                            tglOff.value = picked;

                            tglOffPlaceHolder.text = DateFormat(
                              'dd MMM yyyy',
                            ).format(tglOff.value);
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                controller: tglOffPlaceHolder,
                                cursorColor: Palette.primaryColor,
                                decoration:
                                    Themes.formStyleBordered('Tanggal Off',
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

                      // TGL AKHIR
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

                            print(picked);

                            if (picked == null) {
                              return;
                            }

                            tglGanti.value = picked;

                            tglGantiPlaceHolder.text = DateFormat(
                              'dd MMM yyyy',
                            ).format(tglGanti.value);
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                cursorColor: Palette.primaryColor,
                                controller: tglGantiPlaceHolder,
                                decoration:
                                    Themes.formStyleBordered('Tanggal Ganti',
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

                      //
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
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      SizedBox(
                        height: 54,
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VButton(
                            label: 'Submit Ganti Hari',
                            onPressed: () async {
                              final String tglOffClean =
                                  StringUtils.midnightDate(tglOff.value)
                                      .replaceAll('.000', '');
                              final String tglGantiClean =
                                  StringUtils.midnightDate(tglGanti.value)
                                      .replaceAll('.000', '');

                              log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                              log(' ID Absen : ${idAbsenGantiHariTextController.value.text} \n ');
                              log(' Keterangan: ${keteranganTextController.value.text} \n ');
                              log(' Tgl Off: $tglOffClean \n ');
                              log(' Tgl Ganti: $tglGantiClean \n ');

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createGantiHariProvider.notifier)
                                    .submitGantiHari(
                                      tglOff: tglOffClean,
                                      tglGanti: tglGantiClean,
                                      ket: keteranganTextController.text,
                                      idAbsen: int.parse(
                                          idAbsenGantiHariTextController.text),
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
