import 'dart:developer';

import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_button.dart';

import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit_notifier.dart';
import 'package:face_net_authentication/sakit/sakit_list/application/sakit_list_notifier.dart';

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
import '../../../user_helper/user_helper_notifier.dart';

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
    final tglStart = useState(DateTime.now());
    final tglEnd = useState(DateTime.now().add(Duration(days: 1)));

    final spvTextController = useTextEditingController();
    final hrdTextController = useTextEditingController();

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    ref.listen<AsyncValue>(createSakitNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          onDone: () async {
            ref.invalidate(sakitListControllerProvider);

            // if (suratDokterTextController.value == 'DS') {
            //   // final id = await ref
            //   //     .read(createSakitNotifierProvider.notifier)
            //   //     .getLastSubmitSakit();
            //   // context.replaceNamed(
            //   //   RouteNames.sakitUploadRoute,
            //   //   extra: id,
            //   // );
            // } else {
            //   context.pop();
            // }
            context.pop();
          },
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form Sakit ',
        );
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final userHelper = ref.watch(userHelperNotifierProvider);
    final createSakit = ref.watch(createSakitNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: userHelper,
          data: (_) => VAsyncWidgetScaffold<void>(
            value: createSakit,
            data: (_) => VScaffoldWidget(
                appbarColor: Palette.primaryColor,
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

                        // SURAT DOKTER
                        DropdownButtonFormField<String>(
                          elevation: 0,
                          iconSize: 20,
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: Palette.primaryColor),
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
                          height: 16,
                        ),

                        // TGL AWAL
                        Ink(
                          child: InkWell(
                            onTap: () async {
                              final _oneYear = Duration(days: 365);

                              final picked = await showDateRangePicker(
                                context: context,
                                lastDate: DateTime.now().add(_oneYear),
                                firstDate: DateTime.now().subtract(_oneYear),
                              );
                              if (picked != null) {
                                tglStart.value = picked.start;
                                tglEnd.value = picked.end;
                                final _start = DateFormat('dd MMM yyyy')
                                    .format(tglStart.value);
                                final _end = DateFormat('dd MMMM yyyy')
                                    .format(tglEnd.value);
                                tglPlaceholderTextController.text =
                                    '$_start - $_end';
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
                          height: 16,
                        ),

                        // DIAGNOSA
                        TextFormField(
                            maxLines: 2,
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
                          height: 54,
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
                                log(' Tgl Awal: ${tglStart.value} Tgl Akhir: ${tglEnd.value} \n ');
                                log(' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  await ref
                                      .read(
                                          createSakitNotifierProvider.notifier)
                                      .submitSakit(
                                          tglStart: tglStart.value,
                                          tglEnd: tglEnd.value,
                                          keterangan:
                                              diagnosaTextController.text,
                                          surat:
                                              suratDokterTextController.value,
                                          onError: (msg) {
                                            return DialogHelper
                                                .showCustomDialog(
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
      ),
    );
  }
}
