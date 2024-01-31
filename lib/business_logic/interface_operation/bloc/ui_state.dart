import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UiState extends Equatable {
  const UiState();
}

class UiStateHome extends UiState {
  const UiStateHome();

  @override
  List<Object?> get props => [];
}

class UiStateDeleting extends UiState {
  const UiStateDeleting();
  @override
  List<Object?> get props => [];
}

class UiStateDeleteAllAccount extends UiState {
  const UiStateDeleteAllAccount();

  @override
  List<Object?> get props => [];
}

class UiStateCancelAllAccount extends UiState {
  const UiStateCancelAllAccount();

  @override
  List<Object?> get props => [];
}
