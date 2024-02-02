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
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 20.0,
      children: widget.templates,
    );
  }
}
