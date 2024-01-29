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
  // check whether the account has been added into database
  final bool hasAdd;

  const DataStateAddedNewAccount({
    this.hasAdd = false,
    required super.exception,
  });
}

class DataStateLoggedIn extends DataState {
  final DatabaseUser? user;
  const DataStateLoggedIn({required super.exception, required this.user});
}

class DataStateHome extends DataState {
  const DataStateHome({required super.exception});
}
