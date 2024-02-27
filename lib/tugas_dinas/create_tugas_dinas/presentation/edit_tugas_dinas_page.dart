import 'dart:developer';

import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/assets.dart';
import '../../../routes/application/route_names.dart';
import '../../../shared/providers.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../style/style.dart';
import '../../../user_helper/user_helper_notifier.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/v_button.dart';
import '../../../widgets/v_dialogs.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../tugas_dinas_list/application/tugas_dinas_list.dart';
import '../../tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import '../application/create_tugas_dinas_notifier.dart';
import '../application/user_list.dart';

class EditTugasDinasPage extends HookConsumerWidget {
  const EditTugasDinasPage(this.item);

  final TugasDinasList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jenisTugasDinasTextController =
        useTextEditingController(text: item.kategori);

    // final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: item.cUser);

    final pemberiTugasController = useState(UserList(
        idUser: item.idPemberi,
        nama: item.pemberiName,
        fullname: item.pemberiFullname));
    final pemberiTugasPlaceHolderTextController =
        useTextEditingController(text: item.pemberiFullname);

    final perusahaanTextController =
        useTextEditingController(text: item.perusahaan);

    final alamatTextController = useTextEditingController(text: item.lokasi);

    final keteranganTextController = useTextEditingController(text: item.ket);

    final jamTglAwalPlaceholderTextController =
        useTextEditingController(text: item.jamStart);
    final tglAwalTextController = useState(item.tglStart);
    final jamAwalTextController = useState(item.jamStart);

    final jamTglAkhirPlaceholderTextController =
        useTextEditingController(text: item.jamEnd);
    final tglAkhirTextController = useState(item.tglEnd);
    final jamAkhirTextController = useState(item.jamEnd);

    final khusus = useState(item.jenis);

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    ref.listen<AsyncValue>(createTugasDinasNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form Tugas Dinas',
          onDone: () {
            ref.invalidate(tugasDinasListControllerProvider);
            context.pop();
            return Future.value(true);
          },
        );
      }
      return state.showAlertDialogOnError(context);
    });

    final createIzin = ref.watch(createTugasDinasNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final listTugasDinas = ['', 'DK', 'LK'];

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: createIzin,
        data: (_) => VScaffoldWidget(
            appbarColor: Palette.primaryColor,
            scaffoldTitle: 'Create Form Tugas Dinas',
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
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      elevation: 0,
                      iconSize: 20,
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: Palette.primaryColor),
                      decoration: Themes.formStyleBordered(
                        'Jenis Tugas Dinas',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Form tidak boleh kosong';
                        }

                        return null;
                      },
                      value: listTugasDinas.firstWhere(
                        (element) =>
                            element == jenisTugasDinasTextController.text,
                        orElse: () => listTugasDinas.first,
                      ),
                      onChanged: (String? value) {
                        if (value != null) {
                          jenisTugasDinasTextController.text = value;
                        }
                      },
                      items: listTugasDinas
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
                    // NAMA
                    TextFormField(
                        enabled: false,
                        controller: namaTextController,
                        keyboardType: TextInputType.name,
                        cursorColor: Palette.primaryColor,
                        decoration: Themes.formStyleBordered(
                          'Pemohon',
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
                    // PEMBERI TUGAS
                    Ink(
                      child: InkWell(
                        onTap: () async {
                          final UserList? pemberiTugas =
                              await context.pushNamed(
                                  RouteNames.searchPemberiTugasDinasRoute);

                          if (pemberiTugas != null) {
                            log('pemberiTugas ${pemberiTugas.toJson()}');
                            pemberiTugasController.value = pemberiTugas;
                            pemberiTugasPlaceHolderTextController.text =
                                pemberiTugas.fullname!;
                          }
                        },
                        child: IgnorePointer(
                          ignoring: true,
                          child: TextFormField(
                              maxLines: 1,
                              controller: pemberiTugasPlaceHolderTextController,
                              cursorColor: Palette.primaryColor,
                              decoration: Themes.formStyleBordered(
                                'Pemberi Tugas',
                                icon: Icon(Icons.keyboard_arrow_down_rounded,
                                    color: Palette.primaryColor),
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

                    // PERUSAHAAN
                    TextFormField(
                        maxLines: 1,
                        controller: perusahaanTextController,
                        cursorColor: Palette.primaryColor,
                        decoration: Themes.formStyleBordered(
                          'Perusahaan',
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

                    // ALAMAT
                    TextFormField(
                        maxLines: 1,
                        controller: alamatTextController,
                        cursorColor: Palette.primaryColor,
                        decoration: Themes.formStyleBordered(
                          'Alamat',
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

                    // TGL AWAL
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

                            final String tgl = StringUtils.midnightDate(picked)
                                .replaceAll('.000', '');
                            tglAwalTextController.value = tgl;

                            final jam = DateTime(picked.year, picked.month,
                                picked.day, hour!.hour, hour.minute);
                            jamAwalTextController.value =
                                jam.toString().replaceAll('.000', '');

                            final String startPlaceHolder = DateFormat(
                              'dd MMM yyyy HH:mm',
                            ).format(jam);

                            jamTglAwalPlaceholderTextController.text =
                                "$startPlaceHolder";
                          }
                        },
                        child: IgnorePointer(
                          ignoring: true,
                          child: TextFormField(
                              maxLines: 1,
                              cursorColor: Palette.primaryColor,
                              controller: jamTglAwalPlaceholderTextController,
                              decoration:
                                  Themes.formStyleBordered('Tanggal & Jam Awal',
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
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 90)),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 90)),
                          );
                          if (picked != null) {
                            print(picked);
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

                            final String tgl = StringUtils.midnightDate(picked)
                                .replaceAll('.000', '');
                            tglAkhirTextController.value = tgl;

                            final jam = DateTime(picked.year, picked.month,
                                picked.day, hour!.hour, hour.minute);
                            jamAkhirTextController.value =
                                jam.toString().replaceAll('.000', '');

                            final String placeholder = DateFormat(
                              'dd MMM yyyy HH:mm',
                            ).format(jam);

                            jamTglAkhirPlaceholderTextController.text =
                                placeholder;
                          }
                        },
                        child: IgnorePointer(
                          ignoring: true,
                          child: TextFormField(
                              maxLines: 1,
                              cursorColor: Palette.primaryColor,
                              controller: jamTglAkhirPlaceholderTextController,
                              decoration: Themes.formStyleBordered(
                                  'Tanggal & Jam Akhir',
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
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 10.0,
                      child: Row(
                        children: [
                          Checkbox(
                            fillColor:
                                MaterialStatePropertyAll(Colors.transparent),
                            checkColor: Palette.primaryColor,
                            value: khusus.value,
                            onChanged: (val) {
                              if (val != null) khusus.value = val;
                            },
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                  width: 2.0, color: Palette.primaryColor),
                            ),
                          ),
                          Text(
                            'Khusus',
                            style: Themes.customColor(14),
                          )
                        ],
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
                          label: 'Update Form Tugas Dinas',
                          onPressed: () async {
                            log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                            log(' Jenis Tugas Dinas: ${jenisTugasDinasTextController.value.text} \n ');
                            log(' Keterangan: ${keteranganTextController.value.text} \n ');
                            log(' Tanggal: ${tglAwalTextController.value} \n ');
                            log(' Tgl Awal: ${tglAwalTextController.value} \n ');
                            log(' Jam Awal: ${jamAwalTextController.value} \n ');
                            log(' Tgl Akhir: ${tglAkhirTextController.value} \n ');
                            log(' Jam Akhir: ${jamAkhirTextController.value} \n ');

                            final user = ref.read(userNotifierProvider).user;

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await ref
                                  .read(
                                      createTugasDinasNotifierProvider.notifier)
                                  .updateTugasDinas(
                                    id: item.idDinas,
                                    idUser: user.idUser!,
                                    idPemberi:
                                        pemberiTugasController.value.idUser!,
                                    uUser: user.nama!,
                                    tglAwal: tglAwalTextController.value!,
                                    tglAkhir: tglAkhirTextController.value!,
                                    jamAwal: jamAwalTextController.value!,
                                    kategori:
                                        jenisTugasDinasTextController.text,
                                    perusahaan: perusahaanTextController.text,
                                    lokasi: alamatTextController.text,
                                    khusus: khusus.value,
                                    jamAkhir: jamAkhirTextController.value!,
                                    ket: keteranganTextController.text,
                                    onError: (msg) => HapticFeedback.vibrate()
                                        .then((_) => showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (_) => VSimpleDialog(
                                                  color: Palette.red,
                                                  asset: Assets.iconCrossed,
                                                  label: 'Oops',
                                                  labelDescription: msg,
                                                ))),
                                  );
                            }
                          }),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
