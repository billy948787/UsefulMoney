import 'package:flutter/material.dart';
import 'package:usefulmoney/utils/dialogs/generic_dialog.dart';

Future<bool> showResetDialog({required BuildContext context}) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Reset',
    content: '你確定想要重置嗎?',
    optionsBuilder: () => {
      '否': false,
      '是': true,
    },
  ).then((value) => value ?? false);
}
