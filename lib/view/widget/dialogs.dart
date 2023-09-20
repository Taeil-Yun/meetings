import 'dart:developer';
import 'package:flutter/material.dart';

/// 긍/부정 버튼(확인, 취소) 다이얼로그
void showConfirmDialog({
  required Widget body,
  // String? contentString,
  TextAlign? contentTextAlign,
  double horizontalPadding = 12,
  double verticalPadding = 40,
  required BuildContext context,
  required String positiveButtonText,
  required String negativeButtonText,
  required Function() positiveButtonCallback,
  required Function() negativeButtonCallback,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: body,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              try {
                if (negativeButtonCallback != null) {
                  negativeButtonCallback();
                }
              } catch (e) {
                log('[ERROR] $e');
              }
            },
            child: Text(
              negativeButtonText,
              // style: lightTextStyle(),
            ),
          ),
          TextButton(
            onPressed: () {
              try {
                positiveButtonCallback();
              } catch (e) {
                log('[ERROR] $e');
              }
            },
            child: Text(
              positiveButtonText,
            ),
          ),
        ],
    ),
  );
}
