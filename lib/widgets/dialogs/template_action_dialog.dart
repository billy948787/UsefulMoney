import 'package:flutter/material.dart';
import 'package:usefulmoney/utils/enums/template_actions.dart';

class TemplateActionDialog extends StatelessWidget {
  const TemplateActionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Action'),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(TemplateActions.modify);
          },
          child: const Text('Modify'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop(TemplateActions.delete);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
