import 'package:flutter/foundation.dart';

@immutable
abstract class UiEvent {
  const UiEvent();
}

class UiEventDeleteAccounts extends UiEvent {
  final bool cancel;
  const UiEventDeleteAccounts({required this.cancel});
}

class UiEventSelectAllAccountsToDelete extends UiEvent {
  const UiEventSelectAllAccountsToDelete();
}

class UiEventDeselectAllAccount extends UiEvent {
  const UiEventDeselectAllAccount();
}
