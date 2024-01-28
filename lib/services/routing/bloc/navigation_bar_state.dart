import 'package:flutter/foundation.dart';

@immutable
abstract class NavigationBarState {
  final int index;
  const NavigationBarState({required this.index});
}

final class NavigationBarStateInitial extends NavigationBarState {
  const NavigationBarStateInitial({required super.index});
}
