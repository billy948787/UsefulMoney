import 'package:flutter/material.dart';

typedef OnClick = void Function();

class CustomBotton extends StatelessWidget {
  const CustomBotton({
    super.key,
    required this.onClick,
    required this.content,
    required this.icon,
  });

  final OnClick onClick;
  final Icon icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onClick,
      style: const ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: icon,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
