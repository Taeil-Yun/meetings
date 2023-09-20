import 'package:flutter_styled_toast/flutter_styled_toast.dart' as tm;

final ToastManager toastManager = ToastManager._();

class ToastManager {
  ToastManager._();

  final tm.ToastManager _tm = tm.ToastManager();

  /// Toast 메시지 포지션 인덱스
  int toastPosition = 0;

  /// Toast 메세지 포지션 높이
  double toastHeight = 0.0;

  void initToastPosition() {
    toastPosition = 0;
    toastHeight = 0.0;
  }

  void addToastPosition() {
    toastPosition++;
    toastHeight += 50;
  }

  void subtractToastPosition() {
    toastPosition--;
    toastHeight -= 50;
  }

  void dismissAll({bool showAnim = false}) =>
      _tm.dismissAll(showAnim: showAnim);
}
