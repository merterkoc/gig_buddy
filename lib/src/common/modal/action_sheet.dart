import 'package:flutter/cupertino.dart';

class CupertinoAction {
  static void showModalPopup(
    BuildContext context, {
    CupertinoActionSheetAction? cancelButton,
    List<CupertinoActionSheetAction>? actions,
    Widget? title,
    Widget? message,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        cancelButton: cancelButton,
        actions: actions,
        title: title,
        message: message,
      ),
    );
  }
}
