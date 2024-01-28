import 'package:flutter/foundation.dart';
import 'package:usefulmoney/services/data/account_service.dart';

@immutable
abstract class DataState {
  final Exception? exception;
  const DataState({required this.exception});
}

class DataStateInit extends DataState {
  const DataStateInit({required super.exception});
}

class DataStateAddedNewAccount extends DataState {
  // choose whether need to pop the adding view
  final bool needPop;
  // check whether the account has been added into database
  final bool hasAdd;

  const DataStateAddedNewAccount({
    this.needPop = true,
    this.hasAdd = false,
    required super.exception,
  });
}

class DataStateCreatedUser extends DataState {
  final DatabaseUser? user;

  const DataStateCreatedUser({required this.user, required super.exception});
}
