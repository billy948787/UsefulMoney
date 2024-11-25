import 'package:flutter/material.dart' show BuildContext;
import 'package:usefulmoney/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want delete?',
    optionsBuilder: () => {
      'no': false,
      'yes': true,
    },
  ).then((value) => value ?? false);
}
