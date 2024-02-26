// import 'package:face_net_authentication/absen_manual/absen_manual_approve/infrastructure/absen_manual_approve_repository.dart';
// import 'package:face_net_authentication/dt_pc/dt_pc_list/application/dt_pc_list_notifier.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../../absen_manual/absen_manual_list/application/absen_manual_list.dart';
// import '../../../send_wa/application/phone_num.dart';
// import '../../../send_wa/application/send_wa_notifier.dart';
// import '../../../shared/providers.dart';

// import '../../absen_manual_list/application/absen_manual_list.dart';

// import '../infrastructure/absen_manual_approve_remote_service.dart.dart';

// part 'absen_manual_approve_notifier.g.dart';

// @Riverpod(keepAlive: true)
// AbsenManualApproveRemoteService absenManualApproveRemoteService(
//     AbsenManualApproveRemoteServiceRef ref) {
//   return AbsenManualApproveRemoteService(
//       ref.watch(dioProvider), ref.watch(dioRequestProvider));
// }

// @Riverpod(keepAlive: true)
// AbsenManualApproveRepository absenManualApproveRepository(
//     AbsenManualApproveRepositoryRef ref) {
//   return AbsenManualApproveRepository(
//     ref.watch(absenManualApproveRemoteServiceProvider),
//   );
// }

// @riverpod
// class AbsenManualApproveController extends _$AbsenManualApproveController {
//   @override
//   FutureOr<void> build() {}

//   Future<void> _sendWa(
//       {required AbsenManualList item, required String messageContent}) async {
//     final PhoneNum registeredWa = PhoneNum(
//       noTelp1: item.noTelp1,
//       noTelp2: item.noTelp2,
//     );

//     if (registeredWa.noTelp1!.isNotEmpty) {
//       await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
//           phone: int.parse(registeredWa.noTelp1!),
//           idUser: item.idUser,
//           idDept: item.idDept,
//           notifTitle: 'Notifikasi HRMS',
//           notifContent: '$messageContent');
//     } else if (registeredWa.noTelp2!.isNotEmpty) {
//       await ref.read(sendWaNotifierProvider.notifier).sendWaDirect(
//           phone: int.parse(registeredWa.noTelp2!),
//           idUser: item.idUser,
//           idDept: item.idDept,
//           notifTitle: 'Notifikasi HRMS',
//           notifContent: '$messageContent');
//     } else {
//       throw AssertionError(
//           'User yang dituju tidak memiliki nomor telfon. Silahkan hubungi HR ');
//     }
//   }

//   Future<void> approveSpv({
//     required String nama,
//     required AbsenManualList item,
//   }) async {
//     state = const AsyncLoading();

//     try {
//       await ref
//           .read(absenManualApproveRepositoryProvider)
//           .approveSpv(nama: nama, idAbsenMnl: item.idAbsenmnl);
//       final String messageContent =
//           'Izin Absen Manual Anda Sudah Diapprove Oleh Atasan $nama';
//       await _sendWa(item: item, messageContent: messageContent);

//       state = AsyncData<void>('Sukses Melakukan Approve Form Absen Manual');
//     } catch (e) {
//       state = AsyncError(e, StackTrace.current);
//     }
//   }

//   Future<void> unApproveSpv({
//     required String nama,
//     required AbsenManualList item,
//   }) async {
//     state = const AsyncLoading();

//     try {
//       await ref
//           .read(absenManualApproveRepositoryProvider)
//           .unApproveSpv(nama: nama, idAbsenMnl: item.idAbsenmnl);

//       state = AsyncData<void>('Sukses Unapprove Form Absen Manual');
//     } catch (e) {
//       state = AsyncError(e, StackTrace.current);
//     }
//   }

//   Future<void> approveHrd({
//     required String namaHrd,
//     required String note,
//     required AbsenManualList item,
//   }) async {
//     state = const AsyncLoading();

//     try {
//       await ref.read(absenManualApproveRepositoryProvider).approveHrd(
//           namaHrd: namaHrd, note: note, idAbsenMnl: item.idAbsenmnl);

//       final String messageContent =
//           'Izin Absen Manual Anda Sudah Diapprove Oleh HRD $namaHrd';
//       await _sendWa(item: item, messageContent: messageContent);

//       state = AsyncData<void>('Sukses Melakukan Approve Form Absen Manual');
//     } catch (e) {
//       state = AsyncError(e, StackTrace.current);
//     }
//   }

//   Future<void> unApproveHrd({
//     required String namaHrd,
//     required String note,
//     required int idAbsenMnl,
//   }) async {
//     state = const AsyncLoading();

//     try {
//       await ref
//           .read(absenManualApproveRepositoryProvider)
//           .unApproveHrd(nama: namaHrd, note: note, idAbsenMnl: idAbsenMnl);

//       state = AsyncData<void>('Sukses Melakukan Unapprove Form Absen Manual');
//     } catch (e) {
//       state = AsyncError(e, StackTrace.current);
//     }
//   }

//   Future<void> batal({
//     required String nama,
//     required AbsenManualList item,
//   }) async {
//     state = const AsyncLoading();

//     try {
//       await ref.read(absenManualApproveRepositoryProvider).batal(
//             nama: nama,
//             idAbsenMnl: item.idAbsenmnl,
//           );
//       final String messageContent = 'Izin Anda Telah Di Batalkan Oleh : $nama';

//       await _sendWa(item: item, messageContent: messageContent);
//       state = AsyncData<void>('Sukses Membatalkan Form Absen Manual');
//     } catch (e) {
//       state = AsyncError(e, StackTrace.current);
//     }
//   }

//   bool canSpvApprove(AbsenManualList item) {
//     if (item.hrdSta == true) {
//       return false;
//     }

//     if (ref.read(dtPcListControllerProvider.notifier).isHrdOrSpv() == false) {
//       return false;
//     }

//     if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
//       return false;
//     }

//     // if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
//     //     3) {
//     //   return false;
//     // }

//     if (ref.read(userNotifierProvider).user.fullAkses == true) {
//       return true;
//     }

//     return false;
//   }

//   bool canHrdApprove(AbsenManualList item) {
//     if (item.spvSta == false) {
//       return false;
//     }

//     if (item.hrdSta == true) {
//       return false;
//     }

//     if (ref.read(dtPcListControllerProvider.notifier).isHrdOrSpv() == false) {
//       return false;
//     }

//     if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
//       return false;
//     }

//     // if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
//     //     1) {
//     //   return false;
//     // }

//     if (ref.read(userNotifierProvider).user.fullAkses == true) {
//       return true;
//     }

//     return false;
//   }
// }
