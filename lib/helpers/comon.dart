import 'package:flutter/material.dart';

void showToast(BuildContext context, toastMessage) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(toastMessage),
      action: SnackBarAction(
          label: 'HIDE', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
