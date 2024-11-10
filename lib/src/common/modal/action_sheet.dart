import 'package:flutter/cupertino.dart';

class CupertinoAction {
  static show(BuildContext context,{
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
