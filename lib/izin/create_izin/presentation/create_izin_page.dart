import 'dart:developer';

import 'package:face_net_authentication/izin/create_izin/application/create_izin_notifier.dart';
import 'package:face_net_authentication/izin/create_izin/application/jenis_izin_notifier.dart';
import 'package:face_net_authentication/izin/izin_list/application/izin_list_notifier.dart';
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
import '../../../utils/dialog_helper.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../style/style.dart';
import '../../../user_helper/user_helper_notifier.dart';
import '../../../utils/string_utils.dart';
import '../../izin_list/application/jenis_izin.dart';

class CreateIzinPage extends HookConsumerWidget {
  const CreateIzinPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(userNotifierProvider);
    final namaTextController = useTextEditingController(text: nama.user.nama);
    final ptTextController = useTextEditingController(text: nama.user.payroll);

    final keteranganTextController = useTextEditingController();
    final jenisIzinTextController = useState(1);

    final tglPlaceholderTextController = useTextEditingController();
    final tglAwalTextController = useState('');
    final tglAkhirTextController = useState('');

    final spvTextController = useTextEditingController();
    final hrdTextController = useTextEditingController();

    ref.listen<AsyncValue>(userHelperNotifierProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

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

                      // JENIS IZIN
                      VAsyncValueWidget<List<JenisIzin>>(
                        value: jenisIzin,
                        data: (item) => DropdownButtonFormField<JenisIzin>(
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
                              jenisIzinTextController.value = value.idMstIzin!;
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

                      SizedBox(
                        height: 16,
                      ),

                      // TGL AWAL
                      Ink(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              lastDate: DateTime.now().add(Duration(days: 365)),
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
                              log(' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                              log(' Payroll: ${ptTextController.value.text} \n ');
                              log(' Keterangan: ${keteranganTextController.value.text} \n ');
                              log(' Jenis Izin: ${jenisIzinTextController.value} \n ');
                              log(' Tgl Awal: ${tglAwalTextController.value} Tgl Akhir: ${tglAkhirTextController.value} \n ');
                              log(' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                              final totalHari =
                                  DateTime.parse(tglAkhirTextController.value)
                                      .difference(DateTime.parse(
                                          tglAwalTextController.value))
                                      .inDays;
                              log(' Date Diff: $totalHari');
                              final user = ref.read(userNotifierProvider).user;

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await ref
                                    .read(createIzinNotifierProvider.notifier)
                                    .submitIzin(
                                        idUser: user.idUser!,
                                        cUser: user.nama!,
                                        // CHANGE ID USER
                                        tglAwal: tglAwalTextController.value,
                                        tglAkhir: tglAkhirTextController.value,
                                        keterangan:
                                            keteranganTextController.text,
                                        totalHari: totalHari,
                                        ket: keteranganTextController.text,
                                        idMstIzin:
                                            jenisIzinTextController.value,
                                        onError: (msg) =>
                                            DialogHelper.showErrorDialog(
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
