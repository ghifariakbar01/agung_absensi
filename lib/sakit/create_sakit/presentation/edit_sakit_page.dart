import 'dart:developer';

import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_button.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit_notifier.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/assets.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_dialogs.dart';
import '../../../style/style.dart';
import '../../../user_helper/user_helper_notifier.dart';
import '../../../utils/string_utils.dart';
import '../../sakit_list/application/sakit_list.dart';
import '../../sakit_list/application/sakit_list_notifier.dart';

class EditSakitPage extends HookConsumerWidget {
  const EditSakitPage(this.item);

  final SakitList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final ptTextController = useTextEditingController(text: nama.user.payroll);

    final diagnosaTextController = useTextEditingController(text: item.ket);
    final suratDokterTextController = useState(item.surat!.toLowerCase() == 'ts'
        ? 'Tanpa Surat Dokter'
        : 'Dengan Surat Dokter');

    final tglPlaceholderTextController = useTextEditingController(
        text:
            'Dari ${StringUtils.formatTanggal(item.tglStart!)} Sampai ${StringUtils.formatTanggal(item.tglEnd!)}');

    final tglAwalTextController = useState(
        StringUtils.midnightDate(DateTime.parse(item.tglStart!))
            .replaceAll('.000', ''));

    final tglAkhirTextController = useState(
        StringUtils.midnightDate(DateTime.parse(item.tglEnd!))
            .replaceAll('.000', ''));

    final spvTextController = useTextEditingController();
    final hrdTextController = useTextEditingController();

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    ref.listen<AsyncValue>(createSakitNotifierProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(context,
            color: Palette.primaryColor,
            message: 'Sukses Mengupdate Form Sakit ', onDone: () {
          ref.invalidate(sakitListControllerProvider);
          context.pop();
          return Future.value(true);
        });
      }
      return state.showAlertDialogOnError(context);
    });

    final userHelper = ref.watch(userHelperNotifierProvider);
    final createSakit = ref.watch(createSakitNotifierProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: userHelper,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createSakit,
          data: (_) => VScaffoldWidget(
              scaffoldTitle: 'Edit Form Sakit',
              scaffoldBody: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  // DIAGNOSA
                  TextFormField(
                      maxLines: 2,
                      controller: diagnosaTextController,
                      cursorColor: Palette.primaryColor,
                      decoration: Themes.formStyle(
                        'Masukkan diagnosa penyakit',
                      ),
                      style: Themes.customColor(
                        14,
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
                    // value: suratDokterTextController.value,
                    elevation: 16,
                    iconSize: 20,
                    icon: const Icon(Icons.arrow_downward),
                    decoration: Themes.formStyle('Surat Dokter'),
                    // style: const TextStyle(color: Palette.primaryColor),
                    value: suratDokterTextController.value,
                    onChanged: (String? value) {
                      if (value != null) {
                        suratDokterTextController.value = value;
                      }
                    },
                    items: ['Dengan Surat Dokter', 'Tanpa Surat Dokter']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Themes.customColor(10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  // TGL AWAL
                  InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        lastDate: DateTime.now(),
                        firstDate: new DateTime(2021),
                      );
                      if (picked != null) {
                        print(picked);

                        final start = StringUtils.midnightDate(picked.start)
                            .replaceAll('.000', '');
                        final end = StringUtils.midnightDate(picked.end)
                            .replaceAll('.000', '');

                        tglAwalTextController.value = start;
                        tglAkhirTextController.value = end;

                        final startPlaceHolder =
                            StringUtils.formatTanggal(picked.start.toString());
                        final endPlaceHolder =
                            StringUtils.formatTanggal(picked.end.toString());

                        tglPlaceholderTextController.text =
                            'Dari $startPlaceHolder Sampai $endPlaceHolder';

                        log('START $start END $end');
                      }
                    },
                    child: Ink(
                      child: IgnorePointer(
                        ignoring: true,
                        child: TextFormField(
                            maxLines: 1,
                            controller: tglPlaceholderTextController,
                            cursorColor: Palette.primaryColor,
                            decoration: Themes.formStyle(
                              'Masukkan tgl awal',
                            ),
                            style: Themes.customColor(
                              14,
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

                  // SizedBox(
                  //   height: 8,
                  // ),

                  // SPV NOTE
                  // TextFormField(
                  //   maxLines: 2,
                  //   controller: spvTextController,
                  //   cursorColor: Palette.primaryColor,
                  //   decoration: Themes.formStyle(
                  //     'Masukkan SPV Note',
                  //   ),
                  //   style: Themes.customColor(
                  //
                  //     14,
                  //   ),
                  // ),

                  // SizedBox(
                  //   height: 8,
                  // ),

                  // SPV NOTE
                  // TextFormField(
                  //   maxLines: 2,
                  //   controller: hrdTextController,
                  //   cursorColor: Palette.primaryColor,
                  //   decoration: Themes.formStyle(
                  //     'Masukkan HRD Note',
                  //   ),
                  //   style: Themes.customColor(
                  //
                  //     14,
                  //   ),
                  // ),

                  SizedBox(
                    height: 8,
                  ),

                  Expanded(child: Container()),

                  VButton(
                      label: suratDokterTextController.value == 'DS'
                          ? 'Update Form Sakit dan Upload Surat'
                          : 'Update Form Sakit',
                      onPressed: () async {
                        final String suratDokterText =
                            suratDokterTextController.value.toLowerCase() ==
                                    'dengan surat dokter'
                                ? 'DS'
                                : 'TS';

                        log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                        log(' Payroll: ${ptTextController.value.text} \n ');
                        log(' Diagnosa: ${diagnosaTextController.value.text} \n ');
                        log(' Surat Dokter: $suratDokterText \n ');
                        log(' Tgl Awal: ${tglAwalTextController.value} Tgl Akhir: ${tglAkhirTextController.value} \n ');
                        log(' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                        await ref
                            .read(createSakitNotifierProvider.notifier)
                            .updateSakit(
                                id: item.idSakit!,
                                suratDokter: suratDokterText,
                                tglAwal: tglAwalTextController.value,
                                tglAkhir: tglAkhirTextController.value,
                                keterangan: diagnosaTextController.text,
                                onError: (msg) => HapticFeedback.vibrate()
                                    .then((_) => showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (_) => VSimpleDialog(
                                              color: Palette.red,
                                              asset: Assets.iconCrossed,
                                              label: 'Oops',
                                              labelDescription: msg,
                                            ))));
                      })
                ],
              )),
        ),
      ),
    );
  }
}
