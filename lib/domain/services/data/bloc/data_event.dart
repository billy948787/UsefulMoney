import 'package:flutter/foundation.dart';
import 'package:usefulmoney/domain/services/data/type/database_book.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';
import 'package:usefulmoney/utils/enums/template_actions.dart';

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

class DataEventDeleteListAccount extends DataEvent {
  final int? id;
  final bool? needAddtoListOrRemove;
  final bool? wantDelete;
  final List<DatabaseBook>? accounts;

  const DataEventDeleteListAccount(
      {this.id, this.needAddtoListOrRemove, this.wantDelete, this.accounts});
}

class DataEventCreateOrUpdateTemplate extends DataEvent {
  final String? name;
  final bool needPushOrPop;
  final int? id;
  const DataEventCreateOrUpdateTemplate(
      {this.name, required this.needPushOrPop, this.id});
}

class DataEventDeleteTemplate extends DataEvent {
  final int id;
  const DataEventDeleteTemplate({required this.id});
}

class DataEventChooseTemplateAction extends DataEvent {
  final TemplateActions? action;
  final int id;

  const DataEventChooseTemplateAction({required this.action, required this.id});
}