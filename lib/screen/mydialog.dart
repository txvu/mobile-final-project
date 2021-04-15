import 'package:flutter/material.dart';

class MyDialog {
  static void circularProgressStart(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 10.0,
        ),
      ),
    );
  }

  static void circularProgressStop(BuildContext context) {
    Navigator.pop(context);
  }

  static void info({
    @required BuildContext context,
    @required String title,
    @required String content,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
    );
  }
}
