import 'package:flutter/foundation.dart';
import 'package:usefulmoney/business_logic/services/data/account_service.dart';
import 'package:usefulmoney/business_logic/services/data/type/database_book.dart';

@immutable
abstract class DataEvent {
  const DataEvent();
}

class DataEventNewOrUpdateAccount extends DataEvent {
  final bool isAdded;
  final String? name;
  final String? value;
  final bool needGoBack;
  final DatabaseBook? account;

  const DataEventNewOrUpdateAccount({
    this.isAdded = false,
    this.name,
    this.value,
    this.needGoBack = false,
    this.account,
  });
}

class DataEventCreateOrGetUser extends DataEvent {
  const DataEventCreateOrGetUser();
}

class DataEventDeleteAccount extends DataEvent {
  final int id;
  final bool? wantDelete;

  const DataEventDeleteAccount({required this.id, this.wantDelete});
}

class DataEventOpenDatabase extends DataEvent {
  const DataEventOpenDatabase();
}

class DataEventCloseDatabase extends DataEvent {
  const DataEventCloseDatabase();
}

class DataEventResetUser extends DataEvent {
  const DataEventResetUser();
}
