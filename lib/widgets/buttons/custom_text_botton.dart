import 'package:flutter/material.dart';

typedef OnPress = void Function();
typedef OnHold = void Function();

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPress,
    required this.content,
    required this.isPressed,
    required this.onHold,
  });
  final OnPress onPress;
  final String content;
  final bool isPressed;
  final OnHold onHold;

  @override
  Widget build(BuildContext context) {
    if (isPressed) {
      return FilledButton(
        onPressed: () {
          onPress();
        },
        onLongPress: () => onHold(),
        child: Text(content),
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
        child: Text(content),
      );
    }
  }
}
