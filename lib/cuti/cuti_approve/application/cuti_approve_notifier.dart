import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:face_net_authentication/wa_register/application/wa_register_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers.dart';
import '../../../wa_register/application/wa_register.dart';

import '../../cuti_list/application/cuti_list.dart';

import '../infrastructure/sakit_approve_repository.dart';

// part 'cuti_approve_notifier.g.dart';

// @Riverpod(keepAlive: true)
// SakitApproveRemoteService sakitApproveRemoteService(
//     SakitApproveRemoteServiceRef ref) {
//   return SakitApproveRemoteService(
//       ref.watch(dioProvider), ref.watch(dioRequestProvider));
// }

// @Riverpod(keepAlive: true)
// SakitApproveRepository sakitApproveRepository(SakitApproveRepositoryRef ref) {
//   return SakitApproveRepository(
//     ref.watch(sakitApproveRemoteServiceProvider),
//   );
// }

// @riverpod
// class CutiApproveController extends _$CutiApproveController {
//   @override
//   FutureOr<void> build() {}

//   Future<void> _sendWa(
//       {required CutiList itemCuti, required String messageContent}) async {
//     debugger();

//     final WaRegister registeredWa = await ref
//         .read(waRegisterNotifierProvider.notifier)
//         .getCurrentRegisteredWa();

//     if (registeredWa.phone != null) {
//       //
//       await ref.read(sendWaNotifierProvider.notifier).sendWa(
//           phone: int.parse(registeredWa.phone!),
//           idUser: itemCuti.idUser!,
//           // idDept: itemCuti.idDept!,
//           idDept: 1,
//           notifTitle: 'Notifikasi HRMS',
//           notifContent: '$messageContent');
//     } else {
//       //
//       throw AssertionError(
//           'Phone number not Registerd. Daftarkan dahulu nomor Wa Anda di Home');
//     }
//   }

  // Future<void> approveSpv(
  //     {required String nama,
  //     required String note,
  //     required SakitList itemSakit}) async {
  //   state = const AsyncLoading();

  //   try {
  //     final String messageContent =
  //         'Izin Sakit Anda Sudah Diapprove Oleh Atasan $nama';

  //     await _sendWa(itemSakit: itemSakit, messageContent: messageContent);
  //     await ref
  //         .read(sakitApproveRepositoryProvider)
  //         .approveSpv(nama: nama, note: note, idSakit: itemSakit.idSakit!);

  //     state = AsyncData<void>('Sukses Melakukan Approve Form Sakit');
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  // Future<void> unapproveSpv({
  //   required String nama,
  //   required SakitList itemSakit,
  // }) async {
  //   state = const AsyncLoading();

  //   try {
  //     final String messageContent =
  //         'Izin Sakit Anda Sudah Diapprove Oleh Atasan $nama';

  //     await _sendWa(itemSakit: itemSakit, messageContent: messageContent);
  //     await ref
  //         .read(sakitApproveRepositoryProvider)
  //         .unapproveSpv(nama: nama, itemSakit: itemSakit);

  //     state = AsyncData<void>('Sukses Unapprove Form Sakit');
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  // Future<void> approveHrdTanpaSurat({
  //   required String nama,
  //   required String note,
  //   required SakitList itemSakit,
  //   required CreateSakit createSakit,
  // }) async {
  //   state = const AsyncLoading();

  //   try {
  //     final String messageContent =
  //         'Izin Sakit Anda Sudah Diapprove Oleh HRD $nama';

  //     await _sendWa(itemSakit: itemSakit, messageContent: messageContent);
  //     await ref.read(sakitApproveRepositoryProvider).approveHrdTanpaSurat(
  //         nama: nama,
  //         note: note,
  //         itemSakit: itemSakit,
  //         createSakit: createSakit);

  //     state = AsyncData<void>('Sukses Melakukan Approve Form Sakit');
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  // Future<void> approveHrdDenganSurat({
  //   required String nama,
  //   required String note,
  //   required SakitList itemSakit,
  // }) async {
  //   state = const AsyncLoading();

  //   try {
  //     final String messageContent =
  //         'Izin Sakit Anda Sudah Diapprove Oleh HRD $nama';

  //     await _sendWa(itemSakit: itemSakit, messageContent: messageContent);
  //     await ref.read(sakitApproveRepositoryProvider).approveHrdDenganSurat(
  //           nama: nama,
  //           note: note,
  //           itemSakit: itemSakit,
  //         );

  //     state = AsyncData<void>('Sukses Melakukan Approve Form Sakit');
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  // Future<void> unApproveHrdDenganSurat({
  //   required String nama,
  //   required SakitList itemSakit,
  // }) async {
  //   state = const AsyncLoading();

  //   try {
  //     await ref.read(sakitApproveRepositoryProvider).unApproveHrdDenganSurat(
  //           nama: nama,
  //           itemSakit: itemSakit,
  //         );

  //     state = AsyncData<void>('Sukses Unapprove Form Sakit');
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  // Future<void> unApproveHrdTanpaSurat({
  //   required String nama,
  //   required SakitList itemSakit,
  //   required CreateSakit createSakit,
  // }) async {
  //   state = const AsyncLoading();

  //   try {
  //     await ref.read(sakitApproveRepositoryProvider).unApproveHrdTanpaSurat(
  //         nama: nama, itemSakit: itemSakit, createSakit: createSakit);

  //     state = AsyncData<void>('Sukses Unapprove Form Sakit');
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  // Future<void> batal({
  //   required String nama,
  //   required SakitList itemSakit,
  // }) async {
  //   state = const AsyncLoading();

  //   try {
  //     final String messageContent =
  //         'Izin Sakit Anda Telah Di Batalkan Oleh : $nama';

  //     await _sendWa(itemSakit: itemSakit, messageContent: messageContent);
  //     await ref.read(sakitApproveRepositoryProvider).batal(
  //           nama: nama,
  //           itemSakit: itemSakit,
  //         );

  //     state = AsyncData<void>('Sukses Membatalkan Form Sakit');
  //   } catch (e) {
  //     state = AsyncError(e, StackTrace.current);
  //   }
  // }

  // bool canSpvApprove(SakitList item) {
  //   if (item.hrdSta == true) {
  //     return false;
  //   }

  //   if (ref.read(sakitListControllerProvider.notifier).isHrdOrSpv() == false) {
  //     return false;
  //   }

  //   if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
  //     return false;
  //   }

  //   if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
  //       3) {
  //     return false;
  //   }

  //   if (ref.read(userNotifierProvider).user.fullAkses == true) {
  //     return true;
  //   }

  //   return false;
  // }

  // bool canHrdApprove(SakitList item) {
  //   if (item.spvSta == false) {
  //     return false;
  //   }

  //   if (item.hrdSta == true) {
  //     return false;
  //   }

  //   if (ref.read(sakitListControllerProvider.notifier).isHrdOrSpv() == false) {
  //     return false;
  //   }

  //   if (ref.read(userNotifierProvider).user.idUser == item.idUser) {
  //     return false;
  //   }

  //   if (calcDiffSaturdaySunday(DateTime.parse(item.cDate!), DateTime.now()) >=
  //       1) {
  //     return false;
  //   }

  //   if (ref.read(userNotifierProvider).user.fullAkses == true) {
  //     return true;
  //   }

  //   return false;
  // }

