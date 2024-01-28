import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class BookView extends StatefulWidget {
  const BookView({super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlatformAppBar(
          trailingActions: [
            PlatformIconButton(
              icon: Icon(context.platformIcons.add),
              onPressed: () {
                
              },
            )
          ],
        )
      ],
    );
  }
}
