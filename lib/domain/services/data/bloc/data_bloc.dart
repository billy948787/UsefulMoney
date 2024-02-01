import 'package:bloc/bloc.dart';
import 'package:usefulmoney/utils/constants/data_constant.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'dart:developer' as devtool show log;

import 'package:usefulmoney/domain/services/data/type/database_book.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc(String email) : super(const DataStateInit(exception: null)) {
    final AccountService accountService = AccountService();
    List<DatabaseBook> deleteList = [];

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

    on<DataEventNewOrUpdateAccount>((event, emit) async {
      final name = event.name;
      final valueString = event.value;
      final needGoBack = event.needGoBack;
      final account = event.account;
      //user want update the account
      if (account != null && name != null && valueString != null) {
        try {
          final value = int.parse(valueString);
          await accountService.updateAccount(
            id: account.id,
            accountName: name,
            value: value,
          );
          devtool.log('updated');
          emit(const DataStateHome(exception: null));
          return;
        } on Exception catch (e) {
          emit(DataStateAddedOrUpdatedNewAccount(exception: e));
          return;
        }
      } else if (account != null) {
        //user want go to update the account but not update yet.
        emit(DataStateAddedOrUpdatedNewAccount(
            exception: null, account: account));
        return;
      }
      //user is creatint a account
      if (name != null && valueString != null) {
        try {
          final value = int.parse(valueString);
          final user = await accountService.getUserOrCreateUser(email: email);
          accountService.createAccount(
            name: name,
            value: value,
            owner: user,
          );
          emit(const DataStateHome(exception: null));
          return;
        } on Exception catch (e) {
          emit(DataStateAddedOrUpdatedNewAccount(exception: e));
          return;
        }
      }
      if (needGoBack) {
        emit(const DataStateHome(exception: null));
        return;
      } else {
        //user just want go to the view
        emit(const DataStateAddedOrUpdatedNewAccount(
          exception: null,
          hasAdd: false,
        ));
        return;
      }
    });

    on<DataEventDeleteAccount>(
      (event, emit) async {
        final id = event.id;
        final wantDelete = event.wantDelete;

        if (wantDelete == null) {
          emit(DataStateDelete(exception: null, id: id));
          return;
        }
        if (wantDelete) {
          try {
            accountService.deleteAccount(id: id);
            emit(const DataStateHome(exception: null));
          } on Exception catch (e) {
            emit(DataStateDelete(exception: e, id: id));
            return;
          }
        } else {
          emit(const DataStateHome(exception: null));
        }
      },
    );

    on<DataEventOpenDatabase>(
      (event, emit) async {
        try {
          await accountService.open();
          emit(const DataStateDatabaseOpened(exception: null));
        } on Exception catch (e) {
          emit(DataStateDatabaseOpened(exception: e));
        }
      },
    );

    on<DataEventCloseDatabase>(
      (event, emit) async {
        try {
          await accountService.close();
          emit(const DataStateDatabaseClosed(exception: null));
        } on Exception catch (e) {
          emit(DataStateDatabaseClosed(exception: e));
        }
      },
    );

    on<DataEventResetUser>(
      (event, emit) async {
        final user = await accountService.getUser(email: email);
        accountService.deleteAllAccount(userId: user.id);
        accountService.deleteUser(email: defaultEmail);
        accountService.createUser(email: defaultEmail);
        emit(state);
      },
    );

    on<DataEventDeleteListAccount>(
      (event, emit) async {
        final id = event.id;
        final needAddtoListOrRemove = event.needAddtoListOrRemove;
        final wantDelete = event.wantDelete;
        final accounts = event.accounts;
        if (accounts != null && needAddtoListOrRemove != null) {
          if (needAddtoListOrRemove) {
            deleteList.clear();
            deleteList = List.from(accounts);
          } else {
            deleteList.clear();
          }
        }
        if (id != null && needAddtoListOrRemove != null) {
          final account = await accountService.getAccount(id: id);
          if (needAddtoListOrRemove) {
            deleteList.add(account);
          } else {
            deleteList.removeWhere((element) => element.id == id);
          }
        } else if (wantDelete != null && deleteList.isNotEmpty) {
          for (final element in deleteList) {
            await accountService.deleteAccount(id: element.id);
          }
        }
      },
    );
  }
}
