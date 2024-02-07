import 'package:flutter/material.dart';
import 'package:usefulmoney/widgets/buttons/custom_botton.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          children: [
            CustomBotton(),
          ],
        ),
      ),
    );
  }
}
