import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:meeting_room/common/util/toast_manager.dart';

/// 일반적인 피드백 토스트
void showNormalToast({required BuildContext context, required String text}) => showCoredaxToast(context: context,text: text);

/// 에러 토스트
void showNegativeToast({required BuildContext context, required String text}) => showCoredaxToast(
  context: context,
  text: text,
  isError: true,
  backgroundColor: Colors.redAccent,
);

void showCoredaxToast({
  required BuildContext context,
  required String text,
  bool isError = false,
  Color? backgroundColor,
  TextAlign? textAlign,
}) {
  if (isError) toastManager.dismissAll(showAnim: true);
  toastManager.addToastPosition();

  showToastWidget(
    ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400.0,
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: toastManager.toastHeight,
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: backgroundColor ?? const Color(0xff00D8B4),
        ),
        child: InkWell(
          onTap: () {
            toastManager.initToastPosition();
            toastManager.dismissAll(showAnim: true);
          },
          child: Text(
            text,
            textAlign: textAlign ?? TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
    animation: StyledToastAnimation.fade,
    reverseAnimation: StyledToastAnimation.fade,
    animDuration: const Duration(milliseconds: 300),
    context: context,
    onDismiss: () {
      if (isError)
        toastManager.initToastPosition();
      else
        toastManager.subtractToastPosition();
    },
    isIgnoring: false,
    dismissOtherToast: false,
    duration: const Duration(seconds: 3),
  );
}
