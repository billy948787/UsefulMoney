import 'package:flutter/foundation.dart';
import 'package:usefulmoney/constant/data_constant.dart';

@immutable
abstract class DataEvent {
  const DataEvent();
}

class DataEventNewAccount extends DataEvent {
  final bool isAdded;
  final String? name;
  final int? value;
  final bool needGoBack;

  const DataEventNewAccount(
      {this.isAdded = false, this.name, this.value, this.needGoBack = false});
}

class DataEventCreateOrGetUser extends DataEvent {
  const DataEventCreateOrGetUser();
}
