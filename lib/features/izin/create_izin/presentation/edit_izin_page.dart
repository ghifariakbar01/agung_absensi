import 'package:face_net_authentication/utils/logging.dart';

import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_button.dart';
import 'package:face_net_authentication/widgets/v_scaffold_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../../shared/providers.dart';
import '../../../../utils/dialog_helper.dart';
import '../../../../widgets/alert_helper.dart';
import '../../../../widgets/v_async_widget.dart';
import '../../../../style/style.dart';

import '../../../../utils/string_utils.dart';
import '../../izin_list/application/izin_list.dart';
import '../../izin_list/application/izin_list_notifier.dart';
import '../../izin_list/application/jenis_izin.dart';
import '../application/create_izin_notifier.dart';
import '../application/jenis_izin_notifier.dart';

class EditIzinPage extends HookConsumerWidget {
  const EditIzinPage(this.item);

  final IzinList item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).user;
    final namaTextController = useTextEditingController(text: user.nama);

    final keteranganTextController = useTextEditingController(text: item.ket);
    final jenisIzinTextController = useState(item.idMstIzin);

    final spvTextController = useTextEditingController(text: item.spvNote);
    final hrdTextController = useTextEditingController(text: item.hrdNote);

    final tglPlaceholderTextController = useTextEditingController(
      text: _returnPlaceHolderText(DateTimeRange(
        start: item.tglStart!,
        end: item.tglEnd!,
      )),
    );

    final tglStart = useState(item.tglStart!);
    final tglEnd = useState(item.tglEnd!);

    ref.listen<AsyncValue>(createIzinNotifierProvider, (_, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.value != '' &&
          state.hasError == false) {
        return AlertHelper.showSnackBar(context,
            color: Palette.primaryColor,
            message: 'Sukses Mengupdate Form Izin', onDone: () {
          ref.invalidate(izinListControllerProvider);
          context.pop();
          return Future.value(true);
        });
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
              scaffoldTitle: 'Edit Form Izin',
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
                          value: item.firstWhere(
                            (element) =>
                                element.idMstIzin ==
                                jenisIzinTextController.value,
                            orElse: () => item.first,
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
                            tglStart.value = picked.start;
                            tglEnd.value = picked.end;

                            final _start = DateFormat('dd MMM yyyy')
                                .format(tglStart.value);
                            final _end =
                                DateFormat('dd MMMM yyyy').format(tglEnd.value);

                            tglPlaceholderTextController.text =
                                '$_start - $_end';
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
                          controller: keteranganTextController,
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
                          fontWeight: FontWeight.normal,
                        ),
                      ),

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
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      VButton(
                          label: 'Update Form Izin',
                          onPressed: () async {
                            Log.info(
                                ' VARIABLES : \n  Nama : ${namaTextController.value.text} ');
                            Log.info(
                                ' Diagnosa: ${keteranganTextController.value.text} \n ');
                            Log.info(
                                ' Surat Dokter: ${jenisIzinTextController.value}  \n ');
                            Log.info(
                                ' SPV Note : ${spvTextController.value.text} HRD Note : ${hrdTextController.value.text} \n  ');

                            final _tglAkhir =
                                DateFormat('yyyy-MM-dd').format(tglEnd.value);
                            final _tglAwal =
                                DateFormat('yyyy-MM-dd').format(tglStart.value);

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await ref
                                  .read(createIzinNotifierProvider.notifier)
                                  .updateIzin(
                                      tglAkhir: _tglAkhir,
                                      tglAwal: _tglAwal,
                                      idIzin: item.idIzin!,
                                      idUser: item.idUser!,
                                      noteHrd: hrdTextController.text,
                                      noteSpv: spvTextController.text,
                                      ket: keteranganTextController.text
                                          .replaceAll("\n", " "),
                                      idMstIzin: jenisIzinTextController.value!,
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
                          })
                    ],
                  ),
                ),
              )),
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
