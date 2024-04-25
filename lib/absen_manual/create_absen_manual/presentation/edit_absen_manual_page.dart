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
import '../../../utils/string_utils.dart';
import '../../../widgets/v_button.dart';
import '../../../widgets/v_scaffold_widget.dart';

import '../../absen_manual_list/application/absen_manual_list.dart';
import '../../absen_manual_list/application/absen_manual_list_notifier.dart';
import '../application/create_absen_manual_notifier.dart';
import '../application/jenis_absen.dart';

String _returnPlaceHolderText(
  String hour,
) {
  final DateTime jam = DateTime.parse(hour);
  final startPlaceHolder = DateFormat(
    'dd MMM yyyy',
  ).format(jam);

  return "$startPlaceHolder";
}

class EditAbsenManualPage extends HookConsumerWidget {
  const EditAbsenManualPage(this.item);

  final AbsenManualList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final ptTextController = useTextEditingController(text: nama.user.payroll);

    final keteranganTextController = useTextEditingController(text: item.ket);
    final jenisTextController = useState(item.jenisAbsen);

    final tglPlaceholderTextController =
        useTextEditingController(text: _returnPlaceHolderText(item.tgl!));

    final tglTextController = useState(item.tgl);
    final jamAwalTextController = useState(item.jamAwal);
    final jamAwalPlaceholderTextController = useTextEditingController(
        text: DateFormat('HH:mm')
            .format(DateTime.parse(item.jamAwal!))
            .toString());

    final jamAkhirTextController = useState(item.jamAkhir);
    final jamAkhirPlaceholderTextController = useTextEditingController(
        text: DateFormat('HH:mm')
            .format(DateTime.parse(item.jamAkhir!))
            .toString());

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
                            (element) =>
                                element.Kode == jenisTextController.value,
                            orElse: () => list.first,
                          ),
                          onChanged: (JenisAbsen? value) {
                            if (value != null) {
                              jenisTextController.value = value.Kode;
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
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 90)),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 90)),
                            );
                            if (picked != null) {
                              print(picked);

                              final tgl = StringUtils.midnightDate(picked)
                                  .replaceAll('.000', '');

                              tglTextController.value = tgl;

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
                      IgnorePointer(
                        ignoring: tglTextController.value!.isEmpty,
                        child: Ink(
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

                              final tgl = tglTextController.value;
                              final tglDateTime =
                                  DateTime.parse(tglTextController.value!);

                              final jam = DateTime(
                                  tglDateTime.year,
                                  tglDateTime.month,
                                  tglDateTime.day,
                                  hour!.hour,
                                  hour.minute);

                              log('tgl $tgl ');

                              jamAwalTextController.value =
                                  jam.toString().replaceAll('.000', '');
                              jamAwalPlaceholderTextController.text =
                                  DateFormat('HH:mm').format(jam).toString();
                            },
                            child: IgnorePointer(
                              ignoring: true,
                              child: TextFormField(
                                  maxLines: 1,
                                  cursorColor: Palette.primaryColor,
                                  controller: jamAwalPlaceholderTextController,
                                  decoration: Themes.formStyleBordered(
                                      'Jam Awal',
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
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      // JAM AKHIR
                      IgnorePointer(
                        ignoring: //
                            tglTextController.value!.isEmpty &&
                                jamAkhirTextController.value!.isEmpty,
                        child: Ink(
                          child: InkWell(
                            onTap: () async {
                              final jamAwalAddOneHour = TimeOfDay.fromDateTime(
                                  DateTime.parse(jamAwalTextController.value!)
                                      .add(Duration(hours: 1)));

                              final hour = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.input,
                                initialTime: jamAwalAddOneHour,
                                builder: (context, child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );

                              final tgl = tglTextController.value;
                              final tglDateTime =
                                  DateTime.parse(tglTextController.value!);

                              final jam = DateTime(
                                  tglDateTime.year,
                                  tglDateTime.month,
                                  tglDateTime.day,
                                  hour!.hour,
                                  hour.minute);

                              log('tgl $tgl ');

                              jamAkhirTextController.value =
                                  jam.toString().replaceAll('.000', '');
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

                                    final akhir = DateTime.parse(
                                        jamAkhirTextController.value!);
                                    final awal = DateTime.parse(
                                        jamAwalTextController.value!);

                                    if (akhir.difference(awal).inMinutes < 0) {
                                      return 'Jam akhir tidak boleh melewati jam awal';
                                    }

                                    return null;
                                  }),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      //
                      TextFormField(
                          maxLines: 5,
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
                            if (jenisTextController.value!.toLowerCase() ==
                                'lln') {
                              if (item == null) {
                                return 'Bila Pilih Absen Lainnya / Kasus -> Wajib Mengisi Kolom Keterangan';
                              } else if (item.isEmpty) {
                                return 'Bila Pilih Absen Lainnya / Kasus -> Wajib Mengisi Kolom Keterangan';
                              }
                            }

                            return null;
                          }),

                      SizedBox(
                        height: 54,
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VButton(
                            label: 'Edit Absen Manual',
                            onPressed: () async {
                              log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                              log(' Payroll: ${ptTextController.value.text} \n ');
                              log(' Keterangan: ${keteranganTextController.value.text} \n ');
                              log(' Jenis Absen: ${jenisTextController.value} \n ');
                              log(' Tanggal: ${tglTextController.value} \n ');
                              log(' Jam Awal: ${jamAwalTextController.value} \n ');
                              log(' Jam Akhir: ${jamAkhirTextController.value} \n ');

                              final user = ref.read(userNotifierProvider).user;

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createAbsenManualNotifierProvider
                                        .notifier)
                                    .updateAbsenManual(
                                        id: item.idAbsenmnl,
                                        idUser: user.idUser!,
                                        uUser: user.nama!,
                                        tgl: tglTextController.value!,
                                        jamAwal: jamAwalTextController.value!,
                                        jenisAbsen: jenisTextController.value!,
                                        jamAkhir: jamAkhirTextController.value!,
                                        ket: keteranganTextController.text,
                                        onError: (msg) =>
                                            DialogHelper.showCustomDialog(
                                                msg, context));
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
