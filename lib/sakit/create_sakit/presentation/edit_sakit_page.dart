import 'dart:developer';

import 'package:face_net_authentication/shared/providers.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_button.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';
import 'package:face_net_authentication/sakit/create_sakit/application/create_sakit_notifier.dart';

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
import '../../sakit_list/application/sakit_list.dart';
import '../../sakit_list/application/sakit_list_notifier.dart';

class EditSakitPage extends HookConsumerWidget {
  const EditSakitPage(this.item);

  final SakitList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).user;
    final namaTextController = useTextEditingController(text: user.nama);
    final ptTextController = useTextEditingController(text: user.payroll);

    final diagnosaTextController = useTextEditingController(text: item.ket);
    final suratDokterTextController = useState(
        item.surat!.toLowerCase() == 'ts' ? 'Tanpa Surat' : 'Dengan Surat');

    final tglPlaceholderTextController = useTextEditingController(
      text: _returnPlaceHolderText(
        DateTimeRange(
          start: item.tglStart!,
          end: item.tglEnd!,
        ),
      ),
    );

    final tglStart = useState(item.tglStart);
    final tglEnd = useState(item.tglEnd);

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
        return AlertHelper.showSnackBar(context,
            color: Palette.primaryColor,
            message: 'Sukses Mengupdate Form Sakit ', onDone: () {
          ref.invalidate(sakitListControllerProvider);
          context.pop();
          return Future.value(true);
        });
      }
      return state.showAlertDialogOnError(context, ref);
    });

    final userHelper = ref.watch(userHelperNotifierProvider);
    final createSakit = ref.watch(createSakitNotifierProvider);

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
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
                        decoration: Themes.formStyleBordered(
                          'Nama',
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
                      elevation: 16,
                      iconSize: 20,
                      value: suratDokterTextController.value,
                      decoration: Themes.formStyleBordered('Surat Dokter'),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Palette.primaryColor,
                      ),
                      onChanged: (String? value) {
                        if (value != null) {
                          suratDokterTextController.value = value;
                        }
                      },
                      items: ['Dengan Surat', 'Tanpa Surat']
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

                    // TGL
                    InkWell(
                      onTap: () async {
                        final _oneMonth = Duration(days: 30);
                        final _threeDays = Duration(days: 3);

                        final picked = await showDateRangePicker(
                          context: context,
                          lastDate: DateTime.now().add(_threeDays),
                          firstDate: DateTime.now().subtract(_oneMonth),
                        );

                        if (picked != null) {
                          print(picked);
                          tglStart.value = picked.start;
                          tglEnd.value = picked.end;
                          final _start =
                              DateFormat('dd MMM yyyy').format(tglStart.value!);
                          final _end =
                              DateFormat('dd MMMM yyyy').format(tglEnd.value!);
                          tglPlaceholderTextController.text = '$_start - $_end';
                        }
                      },
                      child: Ink(
                        child: IgnorePointer(
                          ignoring: true,
                          child: TextFormField(
                              maxLines: 1,
                              controller: tglPlaceholderTextController,
                              cursorColor: Palette.primaryColor,
                              decoration: Themes.formStyleBordered(
                                'Tanggal',
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

                    SizedBox(
                      height: 16,
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
                          log(' Tgl Awal: ${tglStart.value} Tgl Akhir: ${tglEnd.value} \n ');
                          log(' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                          await ref
                              .read(createSakitNotifierProvider.notifier)
                              .updateSakit(
                                  idSakit: item.idSakit!,
                                  keterangan: diagnosaTextController.text,
                                  surat: suratDokterText,
                                  tglEnd: tglEnd.value!,
                                  tglStart: tglStart.value!,
                                  onError: (msg) =>
                                      DialogHelper.showCustomDialog(
                                        msg,
                                        context,
                                      ));
                        })
                  ],
                )),
          ),
        ),
      ),
    );
  }

  String _returnPlaceHolderText(
    DateTimeRange picked,
  ) {
    final startPlaceHolder = StringUtils.formatTanggal(picked.start.toString());
    final endPlaceHolder = StringUtils.formatTanggal(picked.end.toString());

    return 'Dari $startPlaceHolder Sampai $endPlaceHolder';
  }
}
