import 'package:face_net_authentication/utils/logging.dart';

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

    final spvTextController = useTextEditingController(text: item.spvNote);
    final hrdTextController = useTextEditingController(text: item.hrdNote);

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

    final createSakit = ref.watch(createSakitNotifierProvider);

    final errLog = ref.watch(errLogControllerProvider);

    return KeyboardDismissOnTap(
      child: VAsyncWidgetScaffold<void>(
        value: errLog,
        data: (_) => VAsyncWidgetScaffold<void>(
          value: createSakit,
          data: (_) => VScaffoldWidget(
              scaffoldTitle: 'Edit Form Sakit',
              scaffoldBody: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ListView(
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
                        final _oneYear = Duration(days: 365);

                        final picked = await showDateRangePicker(
                          context: context,
                          lastDate: DateTime.now().add(_oneYear),
                          firstDate: DateTime.now().subtract(_oneYear),
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
                    TextFormField(
                        maxLines: 2,
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
                    TextFormField(
                        controller: spvTextController,
                        cursorColor: Palette.primaryColor,
                        decoration: Themes.formStyleBordered(
                          'Note SPV',
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
                    TextFormField(
                        controller: hrdTextController,
                        cursorColor: Palette.primaryColor,
                        decoration: Themes.formStyleBordered(
                          'Note HRD',
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

                    VButton(
                        label: suratDokterTextController.value == 'DS'
                            ? 'Update Form Sakit dan Upload Surat'
                            : 'Update Form Sakit',
                        onPressed: () async {
                          final String suratDokterText =
                              suratDokterTextController.value
                                      .toLowerCase()
                                      .contains('dengan surat')
                                  ? 'DS'
                                  : 'TS';

                          Log.info(
                              ' VARIABLES : \n  Nama : ${namaTextController.value.text} ');

                          Log.info(
                              ' Diagnosa: ${diagnosaTextController.value.text} \n ');
                          Log.info(' Surat Dokter: $suratDokterText \n ');
                          Log.info(
                              ' Tgl Awal: ${tglStart.value} Tgl Akhir: ${tglEnd.value} \n ');
                          Log.info(
                              ' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                          await ref
                              .read(createSakitNotifierProvider.notifier)
                              .updateSakit(
                                  idSakit: item.idSakit!,
                                  surat: suratDokterText,
                                  tglEnd: tglEnd.value!,
                                  tglStart: tglStart.value!,
                                  noteHrd: hrdTextController.text,
                                  noteSpv: spvTextController.text,
                                  keterangan: diagnosaTextController.text
                                      .replaceAll("\n", " "),
                                  onError: (msg) {
                                    return DialogHelper.showCustomDialog(
                                      msg,
                                      context,
                                    ).then((_) => ref
                                        .read(errLogControllerProvider.notifier)
                                        .sendLog(errMessage: msg));
                                  });
                        })
                  ],
                ),
              )),
        ),
      ),
    );
  }

  String _returnPlaceHolderText(DateTimeRange picked) {
    final startPlaceHolder = StringUtils.formatTanggal(picked.start.toString());
    final endPlaceHolder = StringUtils.formatTanggal(picked.end.toString());

    return 'Dari $startPlaceHolder Sampai $endPlaceHolder';
  }
}
