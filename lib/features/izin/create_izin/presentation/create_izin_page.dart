import 'package:face_net_authentication/utils/logging.dart';

import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_button.dart';

import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../../utils/dialog_helper.dart';
import '../../../../widgets/alert_helper.dart';
import '../../../../widgets/v_async_widget.dart';
import '../../../../style/style.dart';

import '../../../../utils/string_utils.dart';
import '../../izin_list/application/izin_list_notifier.dart';
import '../../izin_list/application/jenis_izin.dart';
import '../application/create_izin_notifier.dart';
import '../application/jenis_izin_notifier.dart';

class CreateIzinPage extends HookConsumerWidget {
  const CreateIzinPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).user;
    final namaTextController = useTextEditingController(text: user.nama);

    final keteranganTextController = useTextEditingController();
    final jenisIzinTextController = useState(1);

    final tglPlaceholderTextController = useTextEditingController();
    final tglAwalTextController = useState('');
    final tglAkhirTextController = useState('');

    final spvTextController = useTextEditingController();
    final hrdTextController = useTextEditingController();

    ref.listen<AsyncValue>(createIzinNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(
          context,
          color: Palette.primaryColor,
          message: 'Sukses Menginput Form Izin',
          onDone: () {
            ref.invalidate(izinListControllerProvider);
            context.pop();
            return Future.value(true);
          },
        );
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final createIzin = ref.watch(createIzinNotifierProvider);
    final jenisIzin = ref.watch(jenisIzinNotifierProvider);

    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createIzin,
          data: (_) => VScaffoldWidget(
              appbarColor: Palette.primaryColor,
              scaffoldTitle: 'Create Form Izin',
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

                      // JENIS IZIN
                      VAsyncValueWidget<List<JenisIzin>>(
                        value: jenisIzin,
                        data: (item) => SizedBox(
                          height: 50,
                          child: DropdownButtonFormField<JenisIzin>(
                            elevation: 0,
                            iconSize: 20,
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: Palette.primaryColor),
                            decoration: Themes.formStyleBordered(
                              'Jenis Izin',
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Form tidak boleh kosong';
                              }

                              if (value.nama!.isEmpty) {
                                return 'Form tidak boleh kosong';
                              }
                              return null;
                            },
                            onChanged: (JenisIzin? value) {
                              if (value != null) {
                                jenisIzinTextController.value =
                                    value.idMstIzin!;
                              }
                            },
                            isExpanded: true,
                            items: item.map<DropdownMenuItem<JenisIzin>>(
                                (JenisIzin value) {
                              return DropdownMenuItem<JenisIzin>(
                                value: value,
                                child: Text(
                                  value.nama ?? "",
                                  style: Themes.customColor(
                                    14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
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
                              final start =
                                  StringUtils.midnightDate(picked.start)
                                      .replaceAll('.000', '');
                              final end = StringUtils.midnightDate(picked.end)
                                  .replaceAll('.000', '');

                              tglAwalTextController.value = start;
                              tglAkhirTextController.value = end;

                              final startPlaceHolder = DateFormat(
                                'dd MMM yyyy',
                              ).format(picked.start);
                              final endPlaceHolder = DateFormat(
                                'dd MMM yyyy',
                              ).format(picked.end);

                              tglPlaceholderTextController.text =
                                  '$startPlaceHolder - $endPlaceHolder';
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
                            label: 'Apply Izin',
                            onPressed: () async {
                              Log.info(
                                  ' VARIABLES : \n  Nama : ${namaTextController.value.text} ');

                              Log.info(
                                  ' Keterangan: ${keteranganTextController.value.text} \n ');
                              Log.info(
                                  ' Jenis Izin: ${jenisIzinTextController.value} \n ');
                              Log.info(
                                  ' Tgl Awal: ${tglAwalTextController.value} Tgl Akhir: ${tglAkhirTextController.value} \n ');
                              Log.info(
                                  ' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                              final user = ref.read(userNotifierProvider).user;

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createIzinNotifierProvider.notifier)
                                    .submitIzin(
                                        idUser: user.idUser!,
                                        cUser: user.nama!,
                                        tglAwal: tglAwalTextController.value,
                                        tglAkhir: tglAkhirTextController.value,
                                        ket: keteranganTextController.text
                                            .replaceAll("\n", " "),
                                        idMstIzin:
                                            jenisIzinTextController.value,
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
