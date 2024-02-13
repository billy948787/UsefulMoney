import 'package:bloc/bloc.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'dart:developer' as devtool show log;
import 'package:usefulmoney/domain/services/data/type/database_book.dart';
import 'package:usefulmoney/utils/enums/template_actions.dart';

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
      final isPositive = event.isPositive;
      //user want update the account
      if (account != null &&
          name != null &&
          valueString != null &&
          isPositive != null) {
        try {
          final value = int.parse(valueString);
          isPositive
              ? await accountService.updateAccount(
                  id: account.id,
                  accountName: name,
                  value: value,
                )
              : await accountService.updateAccount(
                  id: account.id,
                  accountName: name,
                  value: -value,
                );
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
      //user is creating a account
      if (name != null && valueString != null && isPositive != null) {
        try {
          final value = int.parse(valueString);
          final user = await accountService.getUserOrCreateUser(email: email);
          isPositive
              ? accountService.createAccount(
                  name: name,
                  value: value,
                  owner: user,
                )
              : accountService.createAccount(
                  name: name,
                  value: -value,
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

    on<DataEventResetDatabase>(
      (event, emit) async {
        final wantReset = event.wantReset;
        if (wantReset == null) {
          emit(const DataStateResetDatabase(needReset: true, exception: null));
          return;
        }
        if (wantReset) {
          try {
            await accountService.resetDatabase(email: email);
            emit(const DataStateResetDatabase(
                needReset: false, exception: null));
          } on Exception catch (e) {
            emit(DataStateResetDatabase(needReset: false, exception: e));
          }
        } else {
          emit(const DataStateResetDatabase(needReset: false, exception: null));
        }
      },
    );
    //刪除一整列表的帳
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
          deleteList.clear();
        }
        emit(state);
      },
    );
    on<DataEventCreateOrUpdateTemplate>(
      (event, emit) async {
        final name = event.name;
        final needPushOrPop = event.needPushOrPop;
        final user = await accountService.getUserOrCreateUser(email: email);
        final id = event.id;
        final type = event.type;
        //go to update
        if (needPushOrPop && id != null) {
          final template = await accountService.getTemplate(id: id);
          emit(DataStateAddedOrUpdatedNewTemplate(
            exception: null,
            needPushOrPop: needPushOrPop,
            template: template,
          ));
          return;
        }
        //go to create
        if (needPushOrPop) {
          emit(DataStateAddedOrUpdatedNewTemplate(
            exception: null,
            needPushOrPop: needPushOrPop,
          ));
          return;
        }
        //actually update
        if (name != null && id != null) {
          try {
            await accountService.updateTemplate(name: name, id: id);
            emit(
              const DataStateAddedOrUpdatedNewTemplate(
                  exception: null, needPushOrPop: false),
            );
            return;
          } on Exception catch (e) {
            emit(DataStateAddedOrUpdatedNewTemplate(
                exception: e, needPushOrPop: false));
            return;
          }
        }

        //actually create
        if (name != null && type != null) {
          try {
            await accountService.createTemplate(
              name: name,
              userId: user.id,
              type: type,
            );
            emit(
              DataStateAddedOrUpdatedNewTemplate(
                  exception: null, needPushOrPop: needPushOrPop),
            );
            return;
          } on Exception catch (e) {
            emit(
              DataStateAddedOrUpdatedNewTemplate(
                  exception: e, needPushOrPop: needPushOrPop),
            );
            return;
          }
        }
      },
    );
    //刪除模板
    on<DataEventDeleteTemplate>(
      (event, emit) async {
        final id = event.id;
        try {
          await accountService.deleteTemplate(id: id);
          emit(const DataStateDeleteTemplate(exception: null));
        } on Exception catch (e) {
          emit(DataStateDeleteTemplate(exception: e));
        }
      },
    );

    on<DataEventChooseTemplateAction>(
      (event, emit) {
        final action = event.action;
        final id = event.id;
        //user just want go to the action dialog
        if (action == null) {
          emit(DataStateChooseTemplateAction(
              id: id, exception: null, hasChoosed: false));
          return;
        }

        switch (action) {
          case TemplateActions.delete:
            add(DataEventDeleteTemplate(id: id));
            break;
          case TemplateActions.modify:
            //send the user to the add update template dialog
            add(DataEventCreateOrUpdateTemplate(needPushOrPop: true, id: id));
            break;
          case TemplateActions.none:
            add(const DataEventNewOrUpdateAccount(needGoBack: false));
        }
      },
    );
  }
}
