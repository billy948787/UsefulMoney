import 'package:flutter/material.dart';
import 'package:usefulmoney/utililties/dialogs/generic_dialog.dart';

Future<void> showErrorDialog({
  required String title,
  required String content,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: title,
    content: content,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
