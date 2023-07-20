part of 'sign_in_form_notifier.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required UserId userId,
    required Email email,
    required IdKaryawan idKaryawan,
    required Password password,
    required PTName ptServerSelected,
    required String ptDropdownSelected,
    required List<String> ptDropdownList,
    required Map<String, List<String>> ptMap,
    required bool showErrorMessages,
    required bool isSubmitting,
    required bool isChecked,
    required Option<Either<AuthFailure, Unit>> failureOrSuccessOption,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
        userId: UserId(''),
        email: Email(''),
        idKaryawan: IdKaryawan(''),
        password: Password(''),
        ptServerSelected: PTName('gs_12'),
        ptDropdownSelected: 'PT Agung Citra Transformasi',
        ptDropdownList: [
          'PT Agung Citra Transformasi',
          'PT Agung Transina Raya',
          'PT Agung Lintas Raya',
          'PT Agung Jasa Logistik',
          'PT Agung Tama Raya',
          'PT Agung Raya'
        ],
        ptMap: {
          'gs_12': [
            'PT Agung Citra Transformasi',
            'PT Agung Transina Raya',
            'PT Agung Lintas Raya'
          ],
          'gs_14': ['PT Agung Tama Raya'],
          'gs_18': ['PT Agung Raya'],
          'gs_21': ['PT Agung Jasa Logistik'],
        },
        showErrorMessages: false,
        isSubmitting: false,
        isChecked: false,
        failureOrSuccessOption: none(),
      );
}
