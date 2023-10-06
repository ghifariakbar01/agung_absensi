import 'package:face_net_authentication/application/network_state/network_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NetworkWidget extends ConsumerWidget {
  const NetworkWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final network = ref.watch(networkStateNotifierProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
      child: Container(
        height: 30,
        width: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: network.when(
              //
              online: () => Colors.green,
              //
              offline: () => Colors.red),
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
    );
  }
}
