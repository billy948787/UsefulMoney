import 'package:flutter/material.dart';

class TemplateGridView extends StatefulWidget {
  const TemplateGridView({super.key, required this.templates});
  final List<Widget> templates;

  @override
  State<TemplateGridView> createState() => _TemplateGridViewState();
}

class _TemplateGridViewState extends State<TemplateGridView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        childAspectRatio: 1,
        children: widget.templates,
      ),
    );
  }
}
