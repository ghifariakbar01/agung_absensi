// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../constants/assets.dart';

// import '../../shared/providers.dart';
// import '../../style/style.dart';
// import '../../utils/os_vibrate.dart';
// import '../../wa_register/application/wa_register.dart';
// import '../../wa_register/application/wa_register_notifier.dart';
// import '../../widgets/v_async_widget.dart';
// import '../../widgets/v_dialogs.dart';

// class HomeWa extends ConsumerWidget {
//   const HomeWa(this.onRefresh);

//   final Future<void> Function() onRefresh;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final waRegisterAsync = ref.watch(waRegisterNotifierProvider);
//     final currentlySavedPhoneAsync =
//         ref.watch(currentlySavedPhoneNumberNotifierProvider);

//     final user = ref.watch(userNotifierProvider).user;

//     return VAsyncWidgetScaffold<WaRegister>(
//         value: waRegisterAsync,
//         data: (waRegister) {
//           if (user.nama == 'Ghifar') {
//             return Container();
//           }

//           return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 if (waRegister.phone == null ||
//                     waRegister.isRegistered == null) ...[
//                   SizedBox(
//                     height: 24,
//                   ),
//                   Text(
//                     'Register Notifikasi Whatsapp',
//                     style: Themes.customColor(10, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   HomeRegisterWa(),
//                   SizedBox(
//                     height: 8,
//                   )
//                 ] else if (waRegister.phone != null &&
//                     waRegister.isRegistered != null) ...[
//                   SizedBox(
//                     height: 24,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Register Notifikasi Whatsapp',
//                         style:
//                             Themes.customColor(10, fontWeight: FontWeight.bold),
//                       ),
//                       if (user.noTelp1 != null && user.noTelp2 != null)
//                         VAsyncValueWidget<PhoneNum>(
//                           value: currentlySavedPhoneAsync,
//                           data: (phone) => Ink(
//                             child: InkWell(
//                               onTap: () {
//                                 OSVibrate.vibrate().then((_) => showDialog(
//                                     context: context,
//                                     barrierDismissible: true,
//                                     builder: (_) => VSimpleDialog(
//                                           asset: Assets.iconChecked,
//                                           label: 'Tidak Sesuai ?',
//                                           labelDescription:
//                                               'Jika nomor tidak sesuai, Silahkan hubungi HR untuk mengubah dataD untuk mengubah data',
//                                         )).then((_) => onRefresh()));
//                               },
//                               child: Text(
//                                 '${phone.noTelp1!.isEmpty ? "-" : "${phone.noTelp1}"}'
//                                 '${phone.noTelp2!.isEmpty ? "-" : "/${phone.noTelp2}"}',
//                                 style: Themes.customColor(7,
//                                     fontWeight: FontWeight.bold),
//                                 maxLines: 2,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   HomeRetryRegisterWa(),
//                   SizedBox(
//                     height: 8,
//                   )
//                 ]
//               ]);
//         });
//   }
// }

// class HomeRegisterWa extends ConsumerWidget {
//   const HomeRegisterWa();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SizedBox(
//       height: 68,
//       width: MediaQuery.of(context).size.width,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         separatorBuilder: (context, index) => SizedBox(
//           width: 8,
//         ),
//         itemBuilder: (__, _) => Ink(
//             height: 68,
//             width: 68,
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5), // Shadow color
//                   spreadRadius: 1,
//                   blurRadius: 3,
//                   offset: Offset(-1, 1), // Controls the position of the shadow
//                 ),
//               ],
//             ),
//             child: InkWell(
//               onTap: () => ref
//                   .read(waRegisterNotifierProvider.notifier)
//                   .confirmRegisterWa(context: context),
//               child: Padding(
//                 padding: EdgeInsets.all(4),
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(Assets.iconWa),
//                     Expanded(child: Container()),
//                     Text(
//                       'Register Wa ',
//                       style: Themes.customColor(
//                         7,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )),
//         itemCount: 1,
//       ),
//     );
//   }
// }

// class HomeRetryRegisterWa extends ConsumerWidget {
//   const HomeRetryRegisterWa();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SizedBox(
//       height: 68,
//       width: MediaQuery.of(context).size.width,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         separatorBuilder: (context, index) => SizedBox(
//           width: 8,
//         ),
//         itemBuilder: (__, _) => Ink(
//             height: 68,
//             width: 68,
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5), // Shadow color
//                   spreadRadius: 1,
//                   blurRadius: 3,
//                   offset: Offset(-1, 1), // Controls the position of the shadow
//                 ),
//               ],
//             ),
//             child: InkWell(
//               onTap: () => ref
//                   .read(waRegisterNotifierProvider.notifier)
//                   .retryRegisterWa(context: context),
//               child: Padding(
//                 padding: EdgeInsets.all(4),
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(Assets.iconWaReregist),
//                     Spacer(),
//                     Text(
//                       'Ulangi Register Wa ',
//                       style: Themes.customColor(
//                         6,
//                         fontWeight: FontWeight.normal,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )),
//         itemCount: 1,
//       ),
//     );
//   }
// }
