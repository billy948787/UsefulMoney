import 'package:flutter/material.dart';

typedef OnClick = void Function();

class CustomBotton extends StatelessWidget {
  const CustomBotton({
    super.key,
    required this.onClick,
  });

  final OnClick onClick;

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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.replay_sharp),
          ),
          Text(
            '重置資料(無法復原)',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
