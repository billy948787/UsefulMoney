import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NavigationBarCubit extends Cubit<int> {
  NavigationBarCubit(int index) : super(index);

  void changeIndex(
      {required int target,
      required PlatformTabController controller,
      required BuildContext context}) {
    controller.setIndex(context, target);
  }
}
