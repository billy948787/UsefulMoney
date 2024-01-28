import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

@immutable
abstract class NavigationBarEvent {
  const NavigationBarEvent();
}

class NavigationBarEventGoTo extends NavigationBarEvent {
  final int index;
  final PlatformTabController controller;
  final BuildContext context;
  const NavigationBarEventGoTo(
      {required this.context, required this.index, required this.controller});
}
