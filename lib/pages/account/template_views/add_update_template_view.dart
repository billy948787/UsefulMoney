import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';

class AddUpdateTemplateView extends StatefulWidget {
  const AddUpdateTemplateView({super.key, this.template});
  final DatabaseTemplate? template;

  @override
  State<AddUpdateTemplateView> createState() => _AddUpdateTemplateViewState();
}

class _AddUpdateTemplateViewState extends State<AddUpdateTemplateView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    widget.template != null
        ? _controller.text = widget.template!.name
        : _controller.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<DataBloc>().add(
                          const DataEventNewOrUpdateAccount(
                              needGoBack: false, isAdded: false));
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controller.text != '') {
                        widget.template != null
                            ? context.read<DataBloc>().add(
                                  DataEventCreateOrUpdateTemplate(
                                    needPushOrPop: false,
                                    name: _controller.text,
                                    id: widget.template!.id,
                                  ),
                                )
                            : context.read<DataBloc>().add(
                                  DataEventCreateOrUpdateTemplate(
                                    needPushOrPop: false,
                                    name: _controller.text,
                                  ),
                                );
                        Navigator.of(context).pop();
                      } else {
                        context.read<DataBloc>().add(
                            const DataEventNewOrUpdateAccount(
                                needGoBack: false, isAdded: false));
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
