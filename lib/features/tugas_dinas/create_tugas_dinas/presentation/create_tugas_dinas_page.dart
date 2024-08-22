import 'package:face_net_authentication/utils/logging.dart';

import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../../shared/providers.dart';
import '../../../../utils/dialog_helper.dart';
import '../../../../widgets/alert_helper.dart';
import '../../../../widgets/v_async_widget.dart';
import '../../../../style/style.dart';

import '../../../../widgets/v_button.dart';
import '../../../../widgets/v_scaffold_widget.dart';
import '../../tugas_dinas_list/application/tugas_dinas_list_notifier.dart';
import '../application/create_tugas_dinas_notifier.dart';
// import '../application/jenis_tugas_dinas.dart';
import '../application/jenis_tugas_dinas.dart';
import '../application/user_list.dart';

class CreateTugasDinasPage extends HookConsumerWidget {
  const CreateTugasDinasPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jenisTugasDinasTextController = useTextEditingController(text: 'DK');

    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);

    final pemberiTugasController = useState(UserList.initial());
    final pemberiTugasPlaceHolderTextController = useTextEditingController();

    final perusahaanTextController = useTextEditingController();

    final alamatTextController = useTextEditingController();

    final keteranganTextController = useTextEditingController();

    final jamTglAwalPlaceholderTextController = useTextEditingController();
    final tglAwalTextController = useState('');
    final jamAwalTextController = useState('');

    final jamTglAkhirPlaceholderTextController = useTextEditingController();
    final tglAkhirTextController = useState('');
    final jamAkhirTextController = useState('');

    final khusus = useState(false);

    ref.listen<AsyncValue>(createTugasDinasNotifierProvider, (_, state) async {
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
      return state.showAlertDialogOnError(context, ref);
    });

    final createIzin = ref.watch(createTugasDinasNotifierProvider);

    final jenisTugasDinas = ref.watch(jenisTugasDinasNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
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
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final UserList? pemberiTugas =
                                await context.pushNamed(
                                    RouteNames.searchPemberiTugasDinasRoute);

                            if (pemberiTugas != null) {
                              Log.info('pemberiTugas ${pemberiTugas.toJson()}');
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

                              final String tgl =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              tglAwalTextController.value = tgl;

                              Log.info(
                                  'tglAwalTextController.value ${tglAwalTextController.value}');

                              final jam = DateTime(picked.year, picked.month,
                                  picked.day, hour!.hour, hour.minute);

                              final String startPlaceHolder = DateFormat(
                                'dd MMM yyyy HH:mm',
                              ).format(jam);

                              jamAwalTextController.value = DateFormat(
                                'yyyy-MM-dd HH:mm',
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

                              final String tgl =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              tglAkhirTextController.value = tgl;

                              final jam = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                hour!.hour,
                                hour.minute,
                              );

                              final String placeholder = DateFormat(
                                'dd MMM yyyy HH:mm',
                              ).format(jam);

                              jamAkhirTextController.value = DateFormat(
                                'yyyy-MM-dd HH:mm',
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
                                  WidgetStatePropertyAll(Colors.transparent),
                              checkColor: Palette.primaryColor,
                              value: khusus.value,
                              onChanged: (val) {
                                if (val != null) khusus.value = val;
                              },
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              side: WidgetStateBorderSide.resolveWith(
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
                            label: 'Submit Form Tugas Dinas',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createTugasDinasNotifierProvider
                                        .notifier)
                                    .submitTugasDinas(
                                        idPemberi: pemberiTugasController
                                            .value.idUser!,
                                        tglAwal: tglAwalTextController.value,
                                        tglAkhir: tglAkhirTextController.value,
                                        jamAwal: jamAwalTextController.value,
                                        kategori:
                                            jenisTugasDinasTextController.text,
                                        perusahaan:
                                            perusahaanTextController.text,
                                        lokasi: alamatTextController.text,
                                        jenis: khusus.value,
                                        jamAkhir: jamAkhirTextController.value,
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
