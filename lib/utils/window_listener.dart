import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class CustomWindowListener extends WindowListener {
  final Function()? _onWindowResizedCallback;
  final Function()? _onWindowFocusCallback;
  final Function()? _onWindowBlurCallback;

  CustomWindowListener(
      {Function()? onWindowResized,
      Function()? onWindowFocus,
      Function()? onWindowBlur})
      : _onWindowResizedCallback = onWindowResized,
        _onWindowFocusCallback = onWindowFocus,
        _onWindowBlurCallback = onWindowBlur;

  @override
  void onWindowResized() {
    super.onWindowResized();

    if (_onWindowResizedCallback != null) {
      _onWindowResizedCallback();
    }
  }

  @override
  void onWindowFocus() {
    super.onWindowFocus();

    if (_onWindowFocusCallback != null) {
      _onWindowFocusCallback();
    }
  }

  @override
  void onWindowBlur() {
    super.onWindowBlur();

    if (_onWindowBlurCallback != null) {
      _onWindowBlurCallback();
    }
  }

  @override
  void onWindowUnmaximize() {
    super.onWindowUnmaximize();

    if (_onWindowResizedCallback != null) {
      _onWindowResizedCallback();
    }
  }

  @override
  void onWindowEvent(String eventName) {
    super.onWindowEvent(eventName);

    Get.snackbar('Window Event', 'Event: $eventName');
  }

  @override
  void onWindowRestore() {
    super.onWindowRestore();

    if (_onWindowResizedCallback != null) {
      _onWindowResizedCallback();
    }
  }
}
