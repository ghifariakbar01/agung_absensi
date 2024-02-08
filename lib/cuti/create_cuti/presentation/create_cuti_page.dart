import 'dart:developer';

import 'package:face_net_authentication/cuti/create_cuti/application/jenis_cuti.dart';
import 'package:face_net_authentication/cuti/cuti_list/application/cuti_list_notifier.dart';
import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:face_net_authentication/pages/widgets/v_button.dart';

import 'package:face_net_authentication/pages/widgets/v_scaffold_widget.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../pages/widgets/alert_helper.dart';
import '../../../pages/widgets/v_async_widget.dart';
import '../../../style/style.dart';
import '../../../utils/string_utils.dart';
import '../application/alasan_cuti.dart';
import '../application/create_cuti_notifier.dart';

class CreateCutiPage extends HookConsumerWidget {
  const CreateCutiPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final jenisCutiTextController = useState('');
    final alasanCutiTextController = useState('');

    final keteranganCutiTextController = useTextEditingController();

    final tglPlaceholderTextController = useTextEditingController();
    final tglAwalTextController = useState('');
    final tglAkhirTextController = useState('');

    final createCuti = ref.watch(createCutiNotifierProvider);
    final jenisCuti = ref.watch(jenisCutiNotifierProvider);
    final alasanCuti = ref.watch(alasanCutiNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    ref.listen<AsyncValue>(createCutiNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          onDone: () async {
            ref.invalidate(cutiListControllerProvider);
            context.pop();
          },
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form Cuti ',
        );
      }
      return state.showAlertDialogOnError(context);
    });

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: createCuti,
        data: (_) => VScaffoldWidget(
            appbarColor: Palette.primaryLighter,
            scaffoldTitle: 'Create Form Cuti',
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
                        decoration: Themes.formStyle(
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

                    // Jenis Cuti
                    VAsyncValueWidget<List<JenisCuti>>(
                      value: jenisCuti,
                      data: (list) => DropdownButtonFormField<JenisCuti>(
                        elevation: 0,
                        iconSize: 20,
                        padding: EdgeInsets.all(0),
                        icon: const Icon(Icons.arrow_downward),
                        decoration: Themes.formStyleBordered(
                          'Jenis Cuti',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Form tidak boleh kosong';
                          }

                          return null;
                        },
                        onChanged: (JenisCuti? value) {
                          if (value != null) {
                            jenisCutiTextController.value = value.inisial;
                          }
                        },
                        items: list.map<DropdownMenuItem<JenisCuti>>(
                            (JenisCuti value) {
                          return DropdownMenuItem<JenisCuti>(
                            value: value,
                            child: Text(
                              value.nama,
                              style: Themes.customColor(
                                14,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    // Alasan Cuti
                    VAsyncValueWidget<List<AlasanCuti>>(
                      value: alasanCuti,
                      data: (list) => DropdownButtonFormField<AlasanCuti>(
                        elevation: 0,
                        iconSize: 20,
                        padding: EdgeInsets.all(0),
                        icon: const Icon(Icons.arrow_downward),
                        decoration: Themes.formStyleBordered(
                          'Alasan Cuti',
                        ),
                        onChanged: (AlasanCuti? value) {
                          if (value != null) {
                            alasanCutiTextController.value = value.kode;
                          }
                        },
                        isExpanded: true,
                        items: list.map<DropdownMenuItem<AlasanCuti>>(
                            (AlasanCuti value) {
                          return DropdownMenuItem<AlasanCuti>(
                            value: value,
                            child: Text(
                              value.alasan,
                              style: Themes.customColor(
                                14,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    TextFormField(
                        controller: keteranganCutiTextController,
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

                    SizedBox(
                      height: 8,
                    ),

                    // TGL AWAL
                    Ink(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: new DateTime(2021),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) {
                            print(picked);

                            final start = StringUtils.midnightDate(picked.start)
                                .replaceAll('.000', '');
                            final end = StringUtils.midnightDate(picked.end)
                                .replaceAll('.000', '');

                            tglAwalTextController.value = start;
                            tglAkhirTextController.value = end;

                            final startPlaceHolder = StringUtils.formatTanggal(
                                picked.start.toString());
                            final endPlaceHolder = StringUtils.formatTanggal(
                                picked.end.toString());

                            tglPlaceholderTextController.text =
                                'Dari $startPlaceHolder Sampai $endPlaceHolder';

                            log('START $start END $end');
                          }
                        },
                        child: IgnorePointer(
                          ignoring: true,
                          child: TextFormField(
                              maxLines: 1,
                              cursorColor: Palette.primaryColor,
                              controller: tglPlaceholderTextController,
                              decoration: Themes.formStyleBordered(
                                'Tanggal',
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
                      height: 8,
                    ),

                    Container(
                      height: 58,
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VButton(
                          label: 'Apply Cuti',
                          onPressed: () async {
                            log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                            log(' Jenis Cuti: ${jenisCutiTextController.value} \n ');
                            log(' Alasan: ${alasanCutiTextController.value} \n ');
                            log(' Keterangan: ${keteranganCutiTextController.text} \n ');
                            log(' Tgl PlaceHolder: ${tglPlaceholderTextController.text} \n ');
                            log(' Tgl Awal: ${tglAwalTextController.value} Tgl Akhir: ${tglAkhirTextController.value} \n ');
                            // log(' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // await ref
                              //     .read(createCutiNotifierProvider.notifier)
                              //     .submitCuti(
                              //         tglAwal: tglAwalTextController.value,
                              //         tglAkhir: tglAkhirTextController.value,
                              //         keterangan:
                              //             keteranganCutiTextController.text,
                              //         jenisCuti: jenisCutiTextController.value,
                              //         alasanCuti:
                              //             alasanCutiTextController.value,
                              //         onError: (msg) => HapticFeedback.vibrate()
                              //             .then((_) => showDialog(
                              //                 context: context,
                              //                 barrierDismissible: true,
                              //                 builder: (_) => VSimpleDialog(
                              //                       color: Palette.red,
                              //                       asset: Assets.iconCrossed,
                              //                       label: 'Oops',
                              //                       labelDescription: msg,
                              //                     ))));
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
