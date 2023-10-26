// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../application/absen/absen_state.dart';
// import '../../application/network_state/network_state_notifier.dart';
// import '../../shared/providers.dart';
// import '../../style/style.dart';
// import '../widgets/v_button.dart';
// import '../widgets/v_dialogs.dart';
// import 'absen_button.dart';

// class AbsenReset extends ConsumerWidget {
//   const AbsenReset({required this.isKaryawanShift});

//   final bool isKaryawanShift;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // ABSEN STATE
//     final absen = ref.watch(absenNotifierProvidier);

//     // IS TESTER
//     final isTester = ref.watch(testerNotifierProvider);

//     // LAT, LONG
//     final nearest = ref.watch(geofenceProvider
//         .select((value) => value.nearestCoordinates.remainingDistance));

//     // JARAK MAKSIMUM
//     final minDistance = ref.watch(geofenceProvider
//         .select((value) => value.nearestCoordinates.minDistance));

//     // NETWORK
//     final network = ref.watch(networkStateNotifierProvider);

//     // RESET ABSEN
//     // final buttonIn = ref.watch(buttonInProvider);
//     // final buttonOut = ref.watch(buttonOutProvider);
    // final buttonResetVisibility = ref.watch(buttonResetVisibilityProvider);

//     log('absen $absen');

//     return Column(
//       children: [
       

       
//       ],
//     );
//   }
// }
