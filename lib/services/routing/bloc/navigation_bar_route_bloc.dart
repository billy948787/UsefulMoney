import 'package:bloc/bloc.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_route_event.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_route_state.dart';

class NavigationBarRouteBloc
    extends Bloc<NavigationBarRouteEvent, NavigationBarRouteState> {
  NavigationBarRouteBloc()
      : super(const NavigationBarRouteStateInitial(index: 0)) {
    on<NavigationBarRouteEventGoTo>(
      (event, emit) {
        final index = event.index;
        final controller = event.controller;
        final context = event.context;
        controller.setIndex(context, index);
        emit(NavigationBarRouteStateInitial(index: index));
      },
    );
  }
}
