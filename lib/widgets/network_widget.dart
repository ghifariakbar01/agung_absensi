import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NetworkWidget extends ConsumerStatefulWidget {
  const NetworkWidget();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends ConsumerState<NetworkWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(userNotifierProvider).user;
      if (user.nama == null) {
        return;
      }

      if (user.nama!.isEmpty) {
        //
      } else {
        // final user = ref.read(userNotifierProvider).user;
        // final nama = user.nama ?? 'Ghifar';
        // final password = user.password ?? 'hovvir-7kipqe-cubquH';

        // return ref.read(networkCallbackProvider.notifier).startFetch(
        //       nama: nama,
        //       password: password,
        //     );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // final network = ref.watch(networkStateNotifier2Provider);

    // return VAsyncValueWidget<NetworkState>(
    //   value: network,
    //   data: (netw) => Ink(
    //     height: 30,
    //     width: 30,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(2),
    //       color: netw.when(
    //         offline: () => Colors.red,
    //         online: () => Colors.green,
    //       ),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black.withOpacity(0.2),
    //           spreadRadius: 1,
    //           blurRadius: 2,
    //           offset: Offset(0, 1),
    //         ),
    //       ],
    //     ),
    //     child: InkWell(
    //       onTap: () => DialogHelper.showConfirmationDialog(
    //           context: context,
    //           label: 'Cek status server ? ',
    //           onPressed: () async {
    //             context.pop();
    //             final user = ref.read(userNotifierProvider).user;
    //             final nama = user.nama ?? 'Ghifar';
    //             final password = user.password ?? 'hovvir-7kipqe-cubquH';

    //             return ref.read(networkCallbackProvider.notifier).startFetch(
    //                   nama: nama,
    //                   password: password,
    //                 );
    //           }),
    //       child: Container(),
    //     ),
    //   ),
    // );
  }
}
