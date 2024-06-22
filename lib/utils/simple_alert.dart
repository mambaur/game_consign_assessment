import 'package:flutter/material.dart';

class SimpleAlert {
  static Future<void> show(BuildContext context,
      {String? title,
      String? description,
      bool showYesButton = true,
      bool showCancelButton = true,
      bool barrierDismissible = false,
      Function()? onYes,
      Function()? onCancel}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? ''),
          content: description == null
              ? null
              : SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(description),
                    ],
                  ),
                ),
          actions: <Widget>[
            if (showCancelButton)
              TextButton(
                onPressed: onCancel ?? () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            if (showYesButton)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onYes != null) {
                    onYes.call();
                  }
                },
                child: const Text('Yes'),
              ),
          ],
        );
      },
    );
  }
}
