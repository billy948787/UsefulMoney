import 'package:bloc/bloc.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_event.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_state.dart';

class NavigationBarBloc extends Bloc<NavigationBarEvent, NavigationBarState> {
  NavigationBarBloc() : super(const NavigationBarStateInitial(index: 0)) {
    on<NavigationBarEventGoTo>(
      (event, emit) {
        final index = event.index;
        final controller = event.controller;
        final context = event.context;
        controller.setIndex(context, index);
        emit(NavigationBarStateInitial(index: index));
      },
    );
  }
}
