import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../network_state/application/network_state.dart';
import '../network_state/application/network_state_notifier.dart';
import 'v_async_widget.dart';

class NetworkWidget extends ConsumerWidget {
  const NetworkWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final network = ref.watch(networkStateNotifier2Provider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 18),
      child: VAsyncValueWidget<NetworkState>(
        value: network,
        data: (netw) => Container(
          height: 25,
          width: 8,
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
          child: Container(),
        ),
      ),
    );
  }
}
