import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:usefulmoney/domain/services/data/type/database_book.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';
import 'package:usefulmoney/domain/services/data/type/database_user.dart';

@immutable
abstract class DataState extends Equatable {
  final Exception? exception;
  const DataState({required this.exception});
}

class DataStateInit extends DataState {
  const DataStateInit({required super.exception});

  @override
  List<Object?> get props => [];
}

class DataStateAddedOrUpdatedNewAccount extends DataState {
  // check whether the account has been added into database
  final bool hasAdd;
  final DatabaseBook? account;

  const DataStateAddedOrUpdatedNewAccount({
    this.account,
    this.hasAdd = false,
    required super.exception,
  });

  @override
  List<Object?> get props => [hasAdd, account];
}

class DataStateLoggedIn extends DataState {
  final DatabaseUser? user;
  const DataStateLoggedIn({required super.exception, required this.user});

  @override
  List<Object?> get props => [user];
}

class DataStateHome extends DataState {
  const DataStateHome({required super.exception});

  @override
  List<Object?> get props => [];
}

class DataStateDelete extends DataState {
  final int id;
  const DataStateDelete({required super.exception, required this.id});

  @override
  List<Object?> get props => [id];
}

class DataStateDatabaseOpened extends DataState {
  const DataStateDatabaseOpened({required super.exception});

  @override
  List<Object?> get props => [];
}

class DataStateDatabaseClosed extends DataState {
  const DataStateDatabaseClosed({required super.exception});

  @override
  List<Object?> get props => [];
}

class DataStateAddedOrUpdatedNewTemplate extends DataState {
  const DataStateAddedOrUpdatedNewTemplate(
      {required super.exception, required this.needPushOrPop, this.template});

  final bool needPushOrPop;
  final DatabaseTemplate? template;

  @override
  List<Object?> get props => [needPushOrPop];
}

class DataStateDeleteTemplate extends DataState {
  const DataStateDeleteTemplate({required super.exception});

  @override
  List<Object?> get props => [];
}

class DataStateChooseTemplateAction extends DataState {
  final bool hasChoosed;
  final int id;

  const DataStateChooseTemplateAction(
      {required super.exception, required this.hasChoosed, required this.id});

  @override
  List<Object?> get props => [hasChoosed, id];
}

class DataStateResetDatabase extends DataState {
  final bool needReset;

  const DataStateResetDatabase(
      {required this.needReset, required super.exception});

  @override
  List<Object?> get props => [needReset];
}
