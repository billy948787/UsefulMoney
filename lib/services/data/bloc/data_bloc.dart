import 'package:bloc/bloc.dart';
import 'package:usefulmoney/services/data/account_service.dart';
import 'package:usefulmoney/services/data/bloc/data_event.dart';
import 'package:usefulmoney/services/data/bloc/data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc(String email) : super(const DataStateInit(exception: null)) {
    final AccountService accountService = AccountService();

    on<DataEventCreateOrGetUser>(
      (event, emit) async {
        try {
          final user = await accountService.getUserOrCreateUser(email: email);
          emit(DataStateLoggedIn(
            user: user,
            exception: null,
          ));
        } on Exception catch (e) {
          emit(DataStateLoggedIn(
            user: null,
            exception: e,
          ));
        }
      },
    );

    on<DataEventNewAccount>((event, emit) async {
      final isAdded = event.isAdded;
      final name = event.name;
      final value = event.value;
      final needGoBack = event.needGoBack;
      if (isAdded && name != null && value != null) {
        try {
          final user = await accountService.getUserOrCreateUser(email: email);
          accountService.createAccount(name: name, value: value, owner: user);
          emit(const DataStateAddedNewAccount(
            exception: null,
            hasAdd: true,
          ));
        } on Exception catch (e) {
          emit(DataStateAddedNewAccount(exception: e));
        }
      } else if (needGoBack) {
        emit(const DataStateHome(exception: null));
      } else {
        emit(const DataStateAddedNewAccount(
          exception: null,
          hasAdd: false,
        ));
      }
    });
  }
}
