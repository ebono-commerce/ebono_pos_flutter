import 'package:window_manager/window_manager.dart';

class CustomWindowListener extends WindowListener {
  final Function()? _onWindowResizedCallback;
  final Function()? _onWindowFocusCallback;
  final Function()? _onWindowBlurCallback;
  final Function()? _onWindowRestoreCallback;

  CustomWindowListener({
    Function()? onWindowResized,
    Function()? onWindowFocus,
    Function()? onWindowBlur,
    Function()? onWindowRestore,
  })  : _onWindowResizedCallback = onWindowResized,
        _onWindowFocusCallback = onWindowFocus,
        _onWindowBlurCallback = onWindowBlur,
        _onWindowRestoreCallback = onWindowRestore;

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
  void onWindowRestore() {
    super.onWindowRestore();

    if (_onWindowRestoreCallback != null) {
      _onWindowRestoreCallback();
    }
  }
}
