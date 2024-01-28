import 'package:flutter/foundation.dart';

@immutable
abstract class NavigationBarRouteState {
  final int index;
  const NavigationBarRouteState({required this.index});
}

final class NavigationBarRouteStateInitial extends NavigationBarRouteState {
  const NavigationBarRouteStateInitial({required super.index});
}
