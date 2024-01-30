import 'package:bloc/bloc.dart';
import 'package:usefulmoney/business_logic/interface_operation/bloc/ui_event.dart';
import 'package:usefulmoney/business_logic/interface_operation/bloc/ui_state.dart';

class UiBloc extends Bloc<UiEvent, UiState> {
  UiBloc() : super(const UiStateHome()) {
    on<UiEventDeleteAccounts>(
      (event, emit) {
        if (event.cancel) {
          emit(const UiStateHome());
        } else {
          emit(const UiStateDeleting());
        }
      },
    );
  }
}
