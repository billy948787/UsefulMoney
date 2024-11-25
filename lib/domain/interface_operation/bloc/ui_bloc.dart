import 'package:bloc/bloc.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_event.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_state.dart';

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

    on<UiEventSelectAllAccountsToDelete>(
      (event, emit) {
        emit(const UiStateDeleteAllAccount());
      },
    );

    on<UiEventDeselectAllAccount>(
      (event, emit) {
        emit(const UiStateCancelAllAccount());
      },
    );
  }
}
