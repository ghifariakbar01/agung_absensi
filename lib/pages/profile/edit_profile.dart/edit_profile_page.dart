import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/edit_failure.dart';
import 'package:face_net_authentication/pages/profile/edit_profile.dart/edit_profile_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/routes/route_names.dart';
import '../../../domain/value_objects_copy.dart';
import '../../../shared/providers.dart';
import '../../widgets/alert_helper.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage();

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider.select((value) => value.user));

    ref.listen<Option<Either<EditFailure, Unit>>>(
      editProfileNotifierProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
              (failure) => AlertHelper.showSnackBar(
                    context,
                    message: failure.map(
                      server: (value) => '${value.message} ${value.errorCode}',
                      noConnection: (_) => 'tidak ada koneksi',
                    ),
                  ),
              (_) => ref
                  .read(editProfileNotifierProvider.notifier)
                  .onEditProfile(
                      saveUser: () => ref
                          .read(userNotifierProvider.notifier)
                          .saveUserAfterUpdate(
                              idKaryawan: IdKaryawan(user.idKary ?? ''),
                              password: Password(user.password ?? ''),
                              userId: UserId(user.nama ?? ''),
                              server: PTName(user.ptServer)),
                      onUser: () =>
                          context.replaceNamed(RouteNames.profileNameRoute)))),
    );

    final isSubmitting = ref.watch(
        editProfileNotifierProvider.select((value) => value.isSubmitting));

    return Stack(
      children: [
        EditProfileScaffold(),
        LoadingOverlay(isLoading: isSubmitting)
      ],
    );
  }
}
