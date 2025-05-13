import 'package:window_manager/window_manager.dart';

class CustomWindowListener extends WindowListener {
  final Function()? _onWindowResizedCallback;
  final Function()? _onWindowFocusCallback;

  CustomWindowListener({Function()? onWindowResized, Function()? onWindowFocus})
      : _onWindowResizedCallback = onWindowResized,
        _onWindowFocusCallback = onWindowFocus;

  @override
  void onWindowResized() {
    if (_onWindowResizedCallback != null) {
      _onWindowResizedCallback();
    }
  }

  @override
  void onWindowFocus() {
    if (_onWindowFocusCallback != null) {
      _onWindowFocusCallback();
    }
  }
}
