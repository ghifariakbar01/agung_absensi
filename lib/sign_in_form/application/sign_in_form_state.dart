part of 'sign_in_form_notifier.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required Email email,
    required UserId userId,
    required bool isChecked,
    required bool isKaryawan,
    required bool isSubmitting,
    required Password password,
    required IdKaryawan idKaryawan,
    required bool showErrorMessages,
    required PTName ptServerSelected,
    required String ptDropdownSelected,
    required List<String> ptDropdownList,
    required Map<String, List<String>> ptMap,
    required Option<Either<AuthFailure, Unit>> failureOrSuccessOption,
    required Option<Either<AuthFailure, Unit>> failureOrSuccessOptionRemember,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
      isChecked: true,
      isKaryawan: false,
      isSubmitting: false,
      showErrorMessages: false,
      email: Email(''),
      userId: UserId(''),
      password: Password(''),
      idKaryawan: IdKaryawan(''),
      ptServerSelected: PTName('gs_12'),
      ptDropdownSelected: 'PT Agung Citra Transformasi',
      ptDropdownList: [
        'PT Agung Citra Transformasi',
        // 'PT Agung Transina Raya',
        // 'PT Agung Lintas Raya',
        // 'PT Agung Jasa Logistik',
        // 'PT Agung Tama Raya',
        // 'PT Agung Raya'
      ],
      ptMap: {
        'gs_testing': [
          'PT Agung Citra Transformasi',
          // 'PT Agung Transina Raya',
          // 'PT Agung Lintas Raya'
        ],
        // 'gs_14': ['PT Agung Tama Raya'],
        // 'gs_18': ['PT Agung Raya'],
        // 'gs_21': ['PT Agung Jasa Logistik'],
      },
      failureOrSuccessOption: none(),
      failureOrSuccessOptionRemember: none());
}
