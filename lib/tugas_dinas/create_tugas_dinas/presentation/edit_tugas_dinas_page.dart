import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../utils/dialog_helper.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../style/style.dart';
import '../../../user_helper/user_helper_notifier.dart';
import '../../../widgets/v_button.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../tugas_dinas_list/application/mst_user_list.dart';
import '../../tugas_dinas_list/application/tugas_dinas_list.dart';
import '../../tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import '../application/create_tugas_dinas_notifier.dart';
import '../application/jenis_tugas_dinas.dart';
import '../application/user_list.dart';

class EditTugasDinasPage extends HookConsumerWidget {
  const EditTugasDinasPage(this.item);

  final TugasDinasList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pemberiTugasController = useState(
      // UserList(
      //     idUser: item.idPemberi,
      //     nama: item.pemberiName,
      //     fullname: item.pemberiFullname),
      UserList(
        idUser: item.idPemberi,
        nama: '',
        fullname: '',
      ),
    );

    final namaTextController = useTextEditingController(text: item.cUser);

    final jenisTugasDinasTextController = useTextEditingController(
      text: item.kategori,
    );

    final pemberiTugasPlaceHolderTextController = useTextEditingController(
      text: item.idPemberi.toString(),
    );

    final perusahaanTextController = useTextEditingController(
      text: item.perusahaan,
    );

    final alamatTextController = useTextEditingController(text: item.lokasi);
    final keteranganTextController = useTextEditingController(text: item.ket);

    final jamTglAwalPlaceholderTextController = useTextEditingController(
        text: DateFormat(
      'dd MMM yyyy HH:mm',
    ).format(item.jamStart!));

    final tglAwal = useState(item.tglStart);
    final jamAwal = useState(item.jamStart);

    final jamTglAkhirPlaceholderTextController = useTextEditingController(
        text: DateFormat(
      'dd MMM yyyy HH:mm',
    ).format(item.jamEnd!));

    final tglAkhir = useState(item.tglEnd);
    final jamAkhir = useState(item.jamEnd);

    final khusus = useState(item.jenis);

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    ref.listen<AsyncValue>(createTugasDinasNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: '${state.value}',
          onDone: () {
            ref.invalidate(tugasDinasListControllerProvider);
            context.pop();
            return Future.value(true);
          },
        );
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final createIzin = ref.watch(createTugasDinasNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final jenisTugasDinas = ref.watch(jenisTugasDinasNotifierProvider);

    final errLog = ref.watch(errLogControllerProvider);
    final masterUser = ref.watch(mstUserListNotifierProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createIzin,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryColor,
              scaffoldTitle: 'Edit Form Tugas Dinas',
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
                      VAsyncValueWidget<List<JenisTugasDinas>>(
                        value: jenisTugasDinas,
                        data: (jenis) =>
                            DropdownButtonFormField<JenisTugasDinas>(
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
                          value: jenis.firstWhere(
                            (element) =>
                                element.kode ==
                                jenisTugasDinasTextController.text,
                            orElse: () => jenis.first,
                          ),
                          onChanged: (JenisTugasDinas? value) {
                            if (value != null) {
                              jenisTugasDinasTextController.text = value.kode;
                            }
                          },
                          items: jenis.map<DropdownMenuItem<JenisTugasDinas>>(
                              (JenisTugasDinas value) {
                            return DropdownMenuItem<JenisTugasDinas>(
                              value: value,
                              child: Text(
                                value.kategori,
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
                      VAsyncValueWidget<List<MstUserList>>(
                        value: masterUser,
                        data: (mst) {
                          pemberiTugasPlaceHolderTextController.text = mst
                                  .firstWhereOrNull((element) =>
                                      element.idUser == item.idPemberi)
                                  ?.fullname ??
                              '';

                          return Ink(
                            child: InkWell(
                              onTap: () async {
                                final UserList? pemberiTugas =
                                    await context.pushNamed(RouteNames
                                        .searchPemberiTugasDinasRoute);

                                if (pemberiTugas != null) {
                                  pemberiTugasController.value = pemberiTugas;
                                  pemberiTugasPlaceHolderTextController.text =
                                      pemberiTugas.fullname!;
                                }
                              },
                              child: IgnorePointer(
                                ignoring: true,
                                child: TextFormField(
                                    maxLines: 1,
                                    controller:
                                        pemberiTugasPlaceHolderTextController,
                                    cursorColor: Palette.primaryColor,
                                    decoration: Themes.formStyleBordered(
                                      'Pemberi Tugas',
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
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
                          );
                        },
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
                            final _oneYear = Duration(days: 365);

                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now().add(_oneYear),
                              firstDate: DateTime.now().subtract(_oneYear),
                            );

                            if (picked != null) {
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

                              tglAwal.value = picked;

                              final jam = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                hour!.hour,
                                hour.minute,
                              );

                              jamAwal.value = jam;

                              final String startPlaceHolder = DateFormat(
                                'dd MMM yyyy HH:mm',
                              ).format(jam);

                              jamTglAwalPlaceholderTextController.text =
                                  startPlaceHolder;
                            }
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: TextFormField(
                                maxLines: 1,
                                cursorColor: Palette.primaryColor,
                                controller: jamTglAwalPlaceholderTextController,
                                decoration: Themes.formStyleBordered(
                                    'Tanggal & Jam Awal',
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

                              tglAkhir.value = picked;

                              final jam = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                hour!.hour,
                                hour.minute,
                              );

                              jamAkhir.value = jam;

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
                                controller:
                                    jamTglAkhirPlaceholderTextController,
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
                              log(' Tanggal: ${tglAwal.value} \n ');
                              log(' Tgl Awal: ${tglAwal.value} \n ');
                              log(' Jam Awal: ${jamAwal.value} \n ');
                              log(' Tgl Akhir: ${tglAkhir.value} \n ');
                              log(' Jam Akhir: ${jamAkhir.value} \n ');

                              final _tglAwal = DateFormat(
                                'yyyy-MM-dd',
                              ).format(tglAwal.value!);

                              final _tglAkhir = DateFormat(
                                'yyyy-MM-dd',
                              ).format(tglAkhir.value!);

                              final _jamAwal = DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(jamAwal.value!);

                              final _jamAkhir = DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(jamAkhir.value!);

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createTugasDinasNotifierProvider
                                        .notifier)
                                    .updateTugasDinas(
                                        idDinas: item.idDinas!,
                                        tglAwal: _tglAwal,
                                        tglAkhir: _tglAkhir,
                                        jamAwal: _jamAwal,
                                        jamAkhir: _jamAkhir,
                                        kategori:
                                            jenisTugasDinasTextController.text,
                                        perusahaan:
                                            perusahaanTextController.text,
                                        lokasi: alamatTextController.text,
                                        jenis: khusus.value ?? false,
                                        idPemberi: pemberiTugasController
                                            .value.idUser!,
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
