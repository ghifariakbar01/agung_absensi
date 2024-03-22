import 'package:face_net_authentication/absen_manual/absen_manual_approve/application/absen_manual_approve_notifier.dart';
import 'package:face_net_authentication/absen_manual/absen_manual_list/application/absen_manual_list_notifier.dart';
import 'package:face_net_authentication/absen_manual/absen_manual_list/presentation/absen_manual_list_item.dart';
import 'package:face_net_authentication/cuti/cuti_list/presentation/cuti_list_item.dart';
import 'package:face_net_authentication/dt_pc/dt_pc_list/presentation/dt_pc_list_item.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../../routes/application/route_names.dart';
import '../../../widgets/alert_helper.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../../../style/style.dart';
import '../../absen_manual/absen_manual_list/application/absen_manual_list.dart';
import '../../cuti/cuti_list/application/cuti_list.dart';
import '../../dt_pc/dt_pc_list/application/dt_pc_list.dart';
import '../../ganti_hari/ganti_hari_list/application/ganti_hari_list.dart';
import '../../ganti_hari/ganti_hari_list/presentation/ganti_hari_list_item.dart';
import '../../izin/izin_list/application/izin_list.dart';
import '../../izin/izin_list/presentation/izin_list_item.dart';
import '../../sakit/sakit_list/application/sakit_list.dart';
import '../../sakit/sakit_list/presentation/sakit_list_item.dart';
import '../../tugas_dinas/tugas_dinas_list/application/tugas_dinas_list.dart';
import '../../tugas_dinas/tugas_dinas_list/presentation/tugas_dinas_list_item.dart';

class CentralApprovePage extends HookConsumerWidget {
  const CentralApprovePage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(absenManualListControllerProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final sendWa = ref.watch(sendWaNotifierProvider);
    final absenApprove = ref.watch(absenManualApproveControllerProvider);

    ref.listen<AsyncValue>(absenManualApproveControllerProvider, (_, state) {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        if (ModalRoute.of(context)?.isCurrent != true) {
          context.pop();
        }
        return AlertHelper.showSnackBar(
          context,
          onDone: () async {
            ref.invalidate(absenManualListControllerProvider);
          },
          color: Palette.primaryColor,
          message: '${state.value} ',
        );
      }
    });

    final scrollController = useScrollController();
    final page = useState(0);

    void onScrolled() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        ref.read(absenManualListControllerProvider.notifier).load(
              page: page.value + 1,
            );

        page.value++;
      }
    }

    useEffect(() {
      scrollController.addListener(onScrolled);
      return () => scrollController.removeListener(onScrolled);
    }, [scrollController]);

    final onRefresh = () async {
      page.value = 0;
      await ref.read(absenManualListControllerProvider.notifier).refresh();
      return Future.value();
    };

    final errLog = ref.watch(errLogControllerProvider);

    // final centralApproveList = ref.watch(centralApproveListNotifierProvider);
    final absenManual = ref.watch(absenManualListControllerProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    /*
      absen_manual
      cuti
      dt_pc
      izin
      sakit
      tugas_dinas
      ganti_hari
    */

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold(
        value: absenApprove,
        data: (_) => VAsyncWidgetScaffold(
          value: sendWa,
          data: (_) => VScaffoldTabLayout(
            scaffoldTitle: 'List Central Approval',
            length: 2,
            additionalInfo: Icon(Icons.sort),
            scaffoldFAB: FloatingActionButton.small(
                backgroundColor: Palette.primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => context.pushNamed(
                      RouteNames.createTugasDinasNameRoute,
                    )),
            onPageChanged: onRefresh,
            scaffoldBody: [
              SingleChildScrollView(
                child: SizedBox(
                  height: height,
                  width: width,
                  child: VAsyncValueWidget<List<AbsenManualList>>(
                      value: absenManual,
                      data: (list) {
                        // waiting
                        final _list = list
                            .where((e) =>
                                (e.spvSta == false || e.hrdSta == false) &&
                                e.btlSta == false)
                            .toList();
                        return GenericList<AbsenManualList>(
                          title: 'Absen Manual',
                          list: _list,
                          onRefresh: onRefresh,
                          scrollController: scrollController,
                        );
                      }),
                ),
              ),
              // VAsyncValueWidget<List<TugasDinasList>>,
              Container()
            ],
          ),
        ),
      ),
    );
  }
}

class GenericList<T> extends StatelessWidget {
  const GenericList(
      {Key? key,
      required this.onRefresh,
      required this.scrollController,
      required this.list,
      required this.title})
      : super(key: key);

  final Future<void> Function() onRefresh;
  final ScrollController scrollController;
  final List<T> list;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
          separatorBuilder: (__, index) => SizedBox(
                height: 8,
              ),
          itemCount: list.length + 1,
          itemBuilder: (BuildContext context, int index) => index == list.length
              ? SizedBox(
                  height: 50,
                )
              : index == 0
                  ? Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '$title',
                                style: Themes.customColor(10,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _determineWidget(list[index])
                      ],
                    )
                  : _determineWidget(list[index])),
    );
  }

/*
  absen_manual
  cuti
  dt_pc
  izin
  sakit
  tugas_dinas
  ganti_hari
*/

  _determineWidget(T) {
    // debugger();

    if (T is AbsenManualList) {
      // debugger();
      return AbsenManualListItem(T);
    } else if (T is CutiList) {
      return CutiListItem(T);
    } else if (T is DtPcList) {
      return DtPcListItem(T);
    } else if (T is IzinList) {
      return IzinListItem(T);
    } else if (T is SakitList) {
      return SakitListItem(T);
    } else if (T is TugasDinasList) {
      return TugasDinasListItem(T);
    } else if (T is GantiHariList) {
      return GantiHariListItem(T);
    } else {
      return null;
    }
  }
}
