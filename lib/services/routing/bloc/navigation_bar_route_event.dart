import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

@immutable
abstract class NavigationBarRouteEvent {
  const NavigationBarRouteEvent();
}

class NavigationBarRouteEventGoTo extends NavigationBarRouteEvent {
  final int index;
  final PlatformTabController controller;
  final BuildContext context;
  const NavigationBarRouteEventGoTo(
      {required this.context, required this.index, required this.controller});
}

