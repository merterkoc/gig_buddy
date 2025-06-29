import 'package:flutter/material.dart';

Future<void> showGenericAlertDialog({
  required BuildContext context,
  String title = 'Alert',
  required String content,
  String confirmText = 'OK',
  VoidCallback? onConfirm,
  String? cancelText,
  VoidCallback? onCancel,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) onCancel();
              },
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}

