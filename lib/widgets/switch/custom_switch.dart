import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_cubit.dart';

typedef ActiveAction = void Function();
typedef InactiveAction = void Function();

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    required this.inactiveAction,
    required this.activeAction,
    required this.initValue,
  });

  final ActiveAction activeAction;
  final InactiveAction inactiveAction;
  final bool initValue;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool swichValue;

  @override
  void initState() {
    swichValue = widget.initValue;
    super.initState();
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) {
      return const Icon(
        Icons.add,
        color: Colors.white,
      );
    } else {
      return const Icon(
        Icons.remove,
        color: Colors.white,
      );
    }
  });

  final MaterialStateProperty<Color?> thumbColor =
      MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) {
      return const Color.fromARGB(255, 3, 73, 6);
    } else {
      return const Color.fromARGB(255, 116, 24, 24);
    }
  });

  final MaterialStateProperty<Color?> trackOutlineColor =
      MaterialStateProperty.resolveWith((states) => Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: swichValue,
      thumbColor: thumbColor,
      inactiveTrackColor: Colors.red,
      activeTrackColor: const Color.fromARGB(255, 98, 196, 101),
      thumbIcon: thumbIcon,
      trackOutlineColor: trackOutlineColor,
      onChanged: (value) {
        setState(() {
          swichValue = value;
          value ? widget.activeAction() : widget.inactiveAction();
          context.read<TemplateSelectionCubit>().changeType(value);
        });
      },
    );
  }
}
