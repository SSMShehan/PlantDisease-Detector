import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});

class CameraState {
  final CameraController? controller;
  final bool isInitialized;
  final String? errorMessage;
  
  CameraState({this.controller, this.isInitialized = false, this.errorMessage});

  CameraState copyWith({
    CameraController? controller,
    bool? isInitialized,
    String? errorMessage,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  Future<void> initializeCamera() async {
    if (state.isInitialized && state.controller != null) return;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = state.copyWith(errorMessage: 'No cameras found on device');
        return;
      }

      // Find the first back camera
      CameraDescription? backCamera;
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          backCamera = camera;
          break;
        }
      }
      
      // Fallback to the first available camera if no back camera is found
      final selectedCamera = backCamera ?? cameras.first;

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      
      // Set zoom and flash for the scanner experience if supported
      try {
        await controller.setFlashMode(FlashMode.off);
      } catch (e) {
        // Ignore errors if hardware doesn't support it
      }

      state = state.copyWith(controller: controller, isInitialized: true, errorMessage: null);
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      state = state.copyWith(errorMessage: 'Failed to initialize camera: $e');
    }
  }

  void disposeCamera() {
    state.controller?.dispose();
    state = CameraState();
  }
}
