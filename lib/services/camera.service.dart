// import 'package:camera/camera.dart';

// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// import '../pages/widgets/alert_helper.dart';

// class CameraService {
//   CameraController? _cameraController;
//   CameraController? get cameraController => this._cameraController;

//   InputImageRotation? _cameraRotation;
//   InputImageRotation? get cameraRotation => this._cameraRotation;

//   String? _imagePath;
//   String? get imagePath => this._imagePath;

//   Future<void> initialize(BuildContext context) async {
//     late CameraDescription description;
//     if (_cameraController != null) return;

//     try {
//       description = await _getCameraDescription();
//     } catch (e) {
//       AlertHelper.showSnackBar(context, message: 'Error camera desc : $e');
//     }

//     try {
//       await _setupCameraController(description: description);
//     } catch (e) {
//       AlertHelper.showSnackBar(context, message: 'Error camera setup : $e');
//     }

//     try {
//       if (description.toString() != 'null') {
//         this._cameraRotation = rotationIntToImageRotation(
//           description.sensorOrientation,
//         );
//       }
//     } catch (e) {
//       AlertHelper.showSnackBar(context, message: 'Error camera rotation : $e');
//     }
//   }

//   Future<CameraDescription> _getCameraDescription() async {
//     List<CameraDescription> cameras = await availableCameras();
//     return cameras.firstWhere((CameraDescription camera) =>
//         camera.lensDirection == CameraLensDirection.front);
//   }

//   Future _setupCameraController({
//     required CameraDescription description,
//   }) async {
//     this._cameraController = CameraController(
//       description,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//     await _cameraController?.initialize();
//   }

//   InputImageRotation rotationIntToImageRotation(int rotation) {
//     switch (rotation) {
//       case 90:
//         return InputImageRotation.rotation90deg;
//       case 180:
//         return InputImageRotation.rotation180deg;
//       case 270:
//         return InputImageRotation.rotation270deg;
//       default:
//         return InputImageRotation.rotation0deg;
//     }
//   }

//   Future<XFile?> takePicture(BuildContext context) async {
//     assert(_cameraController != null, 'Camera controller not initialized');
//     //
//     if (_cameraController!.value.isStreamingImages) {
//       try {
//         await _cameraController?.stopImageStream();
//       } catch (e) {
//         AlertHelper.showSnackBar(context,
//             message: 'Error stopping stream : $e');
//       }
//     }

//     if (_cameraController!.value.isTakingPicture == false) {
//       try {
//         XFile? file = await _cameraController?.takePicture();
//         _imagePath = file?.path;
//         return file;
//       } catch (e) {
//         AlertHelper.showSnackBar(context, message: 'Error take picture : $e');
//       }
//     }

//     return null;
//   }

//   Size getImageSize() {
//     assert(_cameraController != null, 'Camera controller not initialized');
//     assert(
//         _cameraController!.value.previewSize != null, 'Preview size is null');
//     return Size(
//       _cameraController!.value.previewSize!.height,
//       _cameraController!.value.previewSize!.width,
//     );
//   }

//   dispose() async {
//     await this._cameraController?.dispose();
//     this._cameraController = null;
//   }
// }
