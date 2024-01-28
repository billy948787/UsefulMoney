import 'package:bloc/bloc.dart';
import 'package:usefulmoney/constant/data_constant.dart';
import 'package:usefulmoney/services/data/account_service.dart';
import 'package:usefulmoney/services/data/bloc/data_event.dart';
import 'package:usefulmoney/services/data/bloc/data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(const DataStateInit(exception: null)) {
    final AccountService accountService = AccountService();

    on<DataEventCreateUser>(
      (event, emit) async {
        const email = defaultEmail;

        try {
          final user = await accountService.getUserOrCreateUser(email: email);
          emit(DataStateCreatedUser(
            user: user,
            exception: null,
          ));
        } on Exception catch (e) {
          emit(DataStateCreatedUser(
            user: null,
            exception: e,
          ));
        }
      },
    );

    on<DataEventNewAccount>((event, emit) async {
      const email = defaultEmail;

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
            needPop: false,
            hasAdd: true,
          ));
        } on Exception catch (e) {
          emit(DataStateAddedNewAccount(exception: e));
        }
      } else if (needGoBack) {
        emit(const DataStateAddedNewAccount(
          exception: null,
          needPop: false,
          hasAdd: false,
        ));
      } else {
        emit(const DataStateAddedNewAccount(
          exception: null,
          needPop: true,
          hasAdd: false,
        ));
      }
    });
  }
}
