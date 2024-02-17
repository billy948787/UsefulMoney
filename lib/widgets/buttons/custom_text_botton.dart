import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_cubit.dart';

typedef OnPress = void Function();
typedef OnHold = void Function();

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPress,
    required this.content,
    required this.onHold,
    required this.template,
  });
  final OnPress onPress;
  final String content;
  final DatabaseTemplate? template;
  final OnHold onHold;

  @override
  Widget build(BuildContext context) {
    if (template != null) {
      final isPressed =
          context.read<TemplateSelectionCubit>().state.isSelect[template];
      if (isPressed != null && isPressed) {
        return FilledButton(
          onPressed: () {
            onPress();
          },
          style: const ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          onLongPress: () => onHold(),
          child: Text(content, style: const TextStyle(fontSize: fontSize)),
        );
      } else {
        return OutlinedButton(
          onPressed: () {
            onPress();
          },
          onLongPress: () => onHold(),
          style: const ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          child: Text(content, style: const TextStyle(fontSize: fontSize)),
        );
      }
    } else {
      return OutlinedButton(
        onPressed: () {
          onPress();
        },
        onLongPress: () => onHold(),
        style: const ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
        child: Text(content, style: const TextStyle(fontSize: fontSize)),
      );
    }
  }
}

const fontSize = 18.0;
