import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_model.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_state.dart';
import 'package:face_net_authentication/domain/riwayat_absen_failure.dart';
import 'package:face_net_authentication/infrastructure/absen/absen_repository.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RiwayatAbsenNotifier extends StateNotifier<RiwayatAbsenState> {
  RiwayatAbsenNotifier(this._absenRepository)
      : super(RiwayatAbsenState.initial());

  final AbsenRepository _absenRepository;

  Future<void> getAbsenRiwayat({
    required int page,
    required String? dateFirst,
    required String? dateSecond,
  }) async {
    Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _absenRepository.getRiwayatAbsen(
        page: page, dateFirst: dateFirst, dateSecond: dateSecond);

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  void isMaxScroll(ScrollController _scrollController) async {}

  void changeAbsenRiwayat(List<RiwayatAbsenModel> listAbsen) {
    state = state.copyWith(riwayatAbsen: [...listAbsen]);
  }

  void changePage(int page) {
    state = state.copyWith(page: page);
  }

  void changeFilter(String? dateFirst, String? dateSecond) {
    state = state.copyWith(dateFirst: dateFirst, dateSecond: dateSecond);
  }

  void changeIsMore(bool isMore) {
    state = state.copyWith(isMore: isMore);
  }

  void startFilter(
      {required Function changePage,
      required Function changeFilter,
      required Function onAllChanged}) async {
    changePage();
    changeFilter();
    await onAllChanged();
  }
}

final riwayatAbsenNotifierProvider =
    StateNotifierProvider.autoDispose<RiwayatAbsenNotifier, RiwayatAbsenState>(
        (ref) => RiwayatAbsenNotifier(ref.watch(absenRepositoryProvider)));

final scrollControllerProvider = StateProvider.autoDispose
    .family<void, ScrollController>((ref, _scrollController) {
  final isMore =
      ref.watch(riwayatAbsenNotifierProvider.select((value) => value.isMore));

  final page =
      ref.watch(riwayatAbsenNotifierProvider.select((value) => value.page));

  final dateFirst = ref
      .watch(riwayatAbsenNotifierProvider.select((value) => value.dateFirst));

  final dateSecond = ref
      .watch(riwayatAbsenNotifierProvider.select((value) => value.dateSecond));

  _scrollController.addListener(() async {
    var nextPageTrigger = 0.9 * _scrollController.position.maxScrollExtent;

    if (_scrollController.position.pixels > nextPageTrigger && isMore) {
      ref.read(riwayatAbsenNotifierProvider.notifier).changePage(page + 1);

      await ref.read(riwayatAbsenNotifierProvider.notifier).getAbsenRiwayat(
          page: page, dateFirst: dateFirst, dateSecond: dateSecond);
    }
  });
});
