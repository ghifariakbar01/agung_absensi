import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../network_state/application/network_state.dart';
import '../network_state/application/network_state_notifier.dart';
import '../utils/dialog_helper.dart';
import 'v_async_widget.dart';

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
      return ref.read(networkCallbackProvider.notifier).startFetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final network = ref.watch(networkStateNotifier2Provider);

    return VAsyncValueWidget<NetworkState>(
      value: network,
      data: (netw) => Ink(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: netw.when(
            offline: () => Colors.red,
            online: () => Colors.green,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => DialogHelper.showConfirmationDialog(
              context: context,
              label: 'Cek status server ? ',
              onPressed: () async {
                context.pop();
                return ref.read(networkCallbackProvider.notifier).startFetch();
              }),
          child: Container(),
        ),
      ),
    );
  }
}
