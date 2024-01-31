import 'dart:developer';

import 'package:face_net_authentication/infrastructure/dio_extensions.dart';
import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:face_net_authentication/pages/widgets/v_button.dart';

import 'package:face_net_authentication/pages/widgets/v_scaffold_widget.dart';
import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit_notifier.dart';
import 'package:face_net_authentication/sakit/sakit_list/application/sakit_list_notifier.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/routes/route_names.dart';
import '../../../constants/assets.dart';
import '../../../pages/widgets/alert_helper.dart';
import '../../../pages/widgets/v_async_widget.dart';
import '../../../pages/widgets/v_dialogs.dart';
import '../../../style/style.dart';
import '../../../user_helper/user_helper_notifier.dart';
import '../../../utils/string_utils.dart';

class CreateSakitPage extends HookConsumerWidget {
  const CreateSakitPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final ptTextController = useTextEditingController(text: nama.user.payroll);

    final diagnosaTextController = useTextEditingController();
    final suratDokterTextController = useState('');

    final tglPlaceholderTextController = useTextEditingController();
    final tglAwalTextController = useState('');
    final tglAkhirTextController = useState('');

    final spvTextController = useTextEditingController();
    final hrdTextController = useTextEditingController();

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });
    ref.listen<AsyncValue>(createSakitNotifierProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    ref.listen<AsyncValue>(createSakitNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          onDone: () async {
            ref.invalidate(sakitListControllerProvider);
            log('suratDokterTextController.value ${suratDokterTextController.value}');

            debugger();

            if (suratDokterTextController.value == 'DS') {
              final id = await ref
                  .read(createSakitNotifierProvider.notifier)
                  .getLastSubmitSakit();
              context.replaceNamed(RouteNames.sakitUploadRoute, extra: id);
            } else {
              context.pop();
            }
          },
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form Sakit ',
        );
      }
    });

    final userHelper = ref.watch(userHelperNotifierProvider);
    final createSakit = ref.watch(createSakitNotifierProvider);

    final isButtonEnabled = suratDokterTextController.value.isNotEmpty &&
        tglAwalTextController.value.isNotEmpty &&
        tglAkhirTextController.value.isNotEmpty &&
        diagnosaTextController.text.isNotEmpty;

    log('isButtonEnabled $isButtonEnabled');

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: userHelper,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createSakit,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryLighter,
              scaffoldTitle: 'Create Form Sakit',
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

                      // PT
                      TextFormField(
                          enabled: false,
                          controller: ptTextController,
                          cursorColor: Palette.primaryColor,
                          keyboardType: TextInputType.name,
                          decoration: Themes.formStyle(
                            'Masukkan pt',
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
                        height: 8,
                      ),

                      // SURAT DOKTER
                      DropdownButtonFormField<String>(
                        elevation: 0,
                        iconSize: 20,
                        padding: EdgeInsets.all(0),
                        icon: const Icon(Icons.arrow_downward),
                        decoration: Themes.formStyleBordered(
                          'Surat Dokter',
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
                        onChanged: (String? value) {
                          if (value != null) {
                            value == 'Dengan Surat Dokter'
                                ? suratDokterTextController.value = 'DS'
                                : suratDokterTextController.value = 'TS';
                          }
                        },
                        items: ['Dengan Surat Dokter', 'Tanpa Surat Dokter']
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
                        height: 8,
                      ),

                      // TGL AWAL
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              lastDate: DateTime.now(),
                              firstDate: new DateTime(2021),
                            );
                            if (picked != null) {
                              print(picked);

                              final start =
                                  StringUtils.midnightDate(picked.start)
                                      .replaceAll('.000', '');
                              final end = StringUtils.midnightDate(picked.end)
                                  .replaceAll('.000', '');

                              tglAwalTextController.value = start;
                              tglAkhirTextController.value = end;

                              final startPlaceHolder =
                                  StringUtils.formatTanggal(
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

                      // DIAGNOSA
                      TextFormField(
                          maxLines: 5,
                          controller: diagnosaTextController,
                          cursorColor: Palette.primaryColor,
                          decoration: Themes.formStyleBordered(
                            'Diagnosa',
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
                        height: 8,
                      ),

                      Container(
                        height: 58,
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VButton(
                            label: suratDokterTextController.value == 'DS'
                                ? 'Apply Leave dan Upload Surat'
                                : 'Apply Leave',
                            onPressed: () async {
                              log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                              log(' Payroll: ${ptTextController.value.text} \n ');
                              log(' Diagnosa: ${diagnosaTextController.value.text} \n ');
                              log(' Surat Dokter: ${suratDokterTextController.value} \n ');
                              log(' Tgl Awal: ${tglAwalTextController.value} Tgl Akhir: ${tglAkhirTextController.value} \n ');
                              log(' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createSakitNotifierProvider.notifier)
                                    .submitSakit(
                                        tglAwal: tglAwalTextController.value,
                                        tglAkhir: tglAkhirTextController.value,
                                        keterangan: diagnosaTextController.text,
                                        suratDokter:
                                            suratDokterTextController.value,
                                        onError: (msg) => HapticFeedback
                                                .vibrate()
                                            .then((_) => showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (_) => VSimpleDialog(
                                                      color: Palette.red,
                                                      asset: Assets.iconCrossed,
                                                      label: 'Oops',
                                                      labelDescription: msg,
                                                    ))));
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
