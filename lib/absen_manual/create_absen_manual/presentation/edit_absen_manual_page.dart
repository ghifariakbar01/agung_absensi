import 'dart:developer';

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
import '../../../widgets/v_button.dart';
import '../../../widgets/v_scaffold_widget.dart';

import '../../absen_manual_list/application/absen_manual_list.dart';
import '../../absen_manual_list/application/absen_manual_list_notifier.dart';
import '../application/create_absen_manual_notifier.dart';
import '../application/jenis_absen.dart';

class EditAbsenManualPage extends HookConsumerWidget {
  const EditAbsenManualPage(this.item);

  final AbsenManualList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final ptTextController = useTextEditingController(text: nama.user.payroll);

    final keteranganTextController = useTextEditingController(text: item.ket);

    final noteSpvTextController = useTextEditingController(text: item.spvNote);
    final noteHrdTextController = useTextEditingController(text: item.hrdNote);

    final tglPlaceholderTextController = useTextEditingController(
        text: DateFormat(
      'dd MMM yyyy',
    ).format(item.tgl!).toString());

    final jamAwalPlaceholderTextController = useTextEditingController(
      text: DateFormat('HH:mm').format(item.jamAwal!).toString(),
    );

    final jamAkhirPlaceholderTextController = useTextEditingController(
      text: DateFormat('HH:mm').format(item.jamAkhir!).toString(),
    );

    final jenis = useState(item.jenisAbsen);

    final _tgl = useState(item.tgl!);
    final jamAwal = useState((item.jamAwal!));
    final jamAkhir = useState(item.jamAkhir!);

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    ref.listen<AsyncValue>(createAbsenManualNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: 'Sukses Edit Form Absen',
          onDone: () {
            ref.invalidate(absenManualListControllerProvider);
            context.pop();
            return Future.value(true);
          },
        );
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final createIzin = ref.watch(createAbsenManualNotifierProvider);
    final jenisAbsen = ref.watch(jenisAbsenManualNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createIzin,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryColor,
              scaffoldTitle: 'Edit Form Absen Manual',
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

                      VAsyncValueWidget<List<JenisAbsen>>(
                        value: jenisAbsen,
                        data: (list) => DropdownButtonFormField<JenisAbsen>(
                          elevation: 0,
                          iconSize: 20,
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Palette.primaryColor),
                          decoration: Themes.formStyleBordered(
                            'Jenis Absen',
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Form tidak boleh kosong';
                            }

                            return null;
                          },
                          value: list.firstWhere(
                            (element) => element.Kode == jenis.value,
                            orElse: () => list.first,
                          ),
                          onChanged: (JenisAbsen? value) {
                            if (value != null) {
                              jenis.value = value.Kode;
                            }
                          },
                          isExpanded: true,
                          items: list.map<DropdownMenuItem<JenisAbsen>>(
                              (JenisAbsen value) {
                            return DropdownMenuItem<JenisAbsen>(
                              value: value,
                              child: Text(
                                value.Nama,
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

                      // TGL
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

                              _tgl.value = picked;

                              final startPlaceHolder = DateFormat(
                                'dd MMM yyyy',
                              ).format(picked);

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
                                decoration:
                                    Themes.formStyleBordered('Tanggal Izin',
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

                      // JAM AWAL
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final hour = await showTimePicker(
                              context: context,
                              initialEntryMode: TimePickerEntryMode.input,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              },
                            );

                            final jam = DateTime(
                                _tgl.value.year,
                                _tgl.value.month,
                                _tgl.value.day,
                                hour!.hour,
                                hour.minute);

                            jamAwal.value = jam;
                            jamAwalPlaceholderTextController.text =
                                DateFormat('HH:mm').format(jam).toString();
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                cursorColor: Palette.primaryColor,
                                controller: jamAwalPlaceholderTextController,
                                decoration: Themes.formStyleBordered('Jam Awal',
                                    icon: Icon(Icons.access_time_sharp)),
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
                            final _oneHour = TimeOfDay.fromDateTime(
                              jamAwal.value.add(Duration(hours: 1)),
                            );

                            final hour = await showTimePicker(
                              context: context,
                              initialTime: _oneHour,
                              initialEntryMode: TimePickerEntryMode.input,
                            );

                            final tglDateTime = _tgl.value;

                            final jam = DateTime(
                                tglDateTime.year,
                                tglDateTime.month,
                                tglDateTime.day,
                                hour!.hour,
                                hour.minute);

                            jamAkhir.value = jam;
                            jamAkhirPlaceholderTextController.text =
                                DateFormat('HH:mm').format(jam).toString();
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                cursorColor: Palette.primaryColor,
                                controller: jamAkhirPlaceholderTextController,
                                decoration: Themes.formStyleBordered(
                                    'Jam Akhir',
                                    icon: Icon(Icons.access_time_sharp)),
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

                                  final akhir = jamAkhir.value;
                                  final awal = jamAwal.value;

                                  if (akhir.difference(awal).inMinutes < 0) {
                                    return 'Jam akhir tidak boleh melewati jam awal';
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
                            if (jenis.value!.toLowerCase() == 'lln') {
                              if (item == null) {
                                return 'Bila Pilih Absen Lainnya / Kasus -> Wajib Mengisi Kolom Keterangan';
                              } else if (item.isEmpty) {
                                return 'Bila Pilih Absen Lainnya / Kasus -> Wajib Mengisi Kolom Keterangan';
                              }
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
                      ),

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
                      ),

                      SizedBox(
                        height: 54,
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VButton(
                            label: 'Edit Absen Manual',
                            onPressed: () async {
                              final tgl = (DateFormat(
                                'dd MMM yyyy',
                              ).format(_tgl.value));

                              final _jamAwal = (DateFormat(
                                'dd MMM yyyy HH:mm',
                              ).format(jamAwal.value));

                              final _jamAkhir = (DateFormat(
                                'dd MMM yyyy HH:mm',
                              ).format(jamAkhir.value));

                              log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                              log(' Payroll: ${ptTextController.value.text} \n ');
                              log(' Keterangan: ${keteranganTextController.value.text} \n ');
                              log(' Jenis Absen: ${jenis.value} \n ');
                              log(' Tanggal: ${_tgl.value} \n ');
                              log(' Jam Awal: $_jamAwal \n ');
                              log(' Jam Akhir: $_jamAkhir \n ');

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createAbsenManualNotifierProvider
                                        .notifier)
                                    .updateAbsenManual(
                                        idAbsenmnl: item.idAbsenmnl!,
                                        tgl: tgl,
                                        jamAwal: _jamAwal,
                                        jamAkhir: _jamAkhir,
                                        jenisAbsen: jenis.value!,
                                        ket: keteranganTextController.text,
                                        noteSpv: noteSpvTextController.text,
                                        noteHrd: noteHrdTextController.text,
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
