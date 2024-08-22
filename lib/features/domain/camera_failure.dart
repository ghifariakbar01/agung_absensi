import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_failure.freezed.dart';

@freezed
class CameraFailure with _$CameraFailure {
  const factory CameraFailure.alreadyInitialized() = _AlreadyInitialized;
  const factory CameraFailure.failedToInitialize() = _FailedToInitialize;
  const factory CameraFailure.failedToSetup() = _FailedToSetup;
  const factory CameraFailure.failedToTakePicture(
      {int? errorCode, String? message}) = _FailedToTakePicture;
  const factory CameraFailure.notAvailable() = _NotAvailable;
}


//  case 'CameraAccessDenied':
//           showInSnackBar('You have denied camera access.');
//           break;
//         case 'CameraAccessDeniedWithoutPrompt':
//           // iOS only
//           showInSnackBar('Please go to Settings app to enable camera access.');
//           break;
//         case 'CameraAccessRestricted':
//           // iOS only
//           showInSnackBar('Camera access is restricted.');
//           break;
//         case 'AudioAccessDenied':
//           showInSnackBar('You have denied audio access.');
//           break;
//         case 'AudioAccessDeniedWithoutPrompt':
//           // iOS only
//           showInSnackBar('Please go to Settings app to enable audio access.');
//           break;
//         case 'AudioAccessRestricted':
//           // iOS only
//           showInSnackBar('Audio access is restricted.');
//           break;
//         default:
//           _showCameraException(e);
//           break;