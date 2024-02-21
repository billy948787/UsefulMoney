import 'package:flutter/foundation.dart';

typedef UpdateLoadingScreen = bool Function(String text);
typedef CloseLoadingScreen = bool Function();

@immutable
class LoadingController {
  final UpdateLoadingScreen update;
  final CloseLoadingScreen close;

  const LoadingController({required this.update, required this.close});
}
