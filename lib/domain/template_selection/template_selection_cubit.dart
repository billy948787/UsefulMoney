import 'package:bloc/bloc.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_state.dart';
import 'dart:developer' as devtool show log;

class TemplateSelectionCubit extends Cubit<TemplateSelectionState> {
  TemplateSelectionCubit()
      : super(const TemplateSelectionState(
          isSelect: {},
          selectedTemplate: null,
          type: false,
        ));
  List<DatabaseTemplate> _list = [];
  Map<DatabaseTemplate, bool> isSelect = {};
  bool _type = false;
  DatabaseTemplate? existingTemplate;
  final AccountService accountService = AccountService();

  void init(List<DatabaseTemplate> list) async {
    _list = list;
    devtool.log('send in list : ${_list.toList()}');
    if (list.isEmpty) {
      return;
    }
    bool isContained = false;
    for (int i = 0; i < list.length; i++) {
      if (isSelect.containsKey(list[i])) {
        isContained = true;
      }
    }
    devtool.log(state.isSelect.toString());
    devtool.log(state.selectedTemplate.toString());
    if (state.isSelect.isEmpty ||
        state.isSelect.length != list.length ||
        !isContained) {
      devtool.log('in the if');
      for (int i = 0; i < list.length; i++) {
        if (existingTemplate != null) {
          if (list[i] == existingTemplate) {
            isSelect.addAll({list[i]: true});
            existingTemplate = null;
          } else {
            isSelect.addAll({list[i]: false});
          }
        } else {
          if (i == 0) {
            isSelect.addAll({list[i]: true});
          } else {
            isSelect.addAll({list[i]: false});
          }
        }
      }
      // devtool.log(existingTemplate.toString());
      // devtool.log(list[0].toString());
      emit(TemplateSelectionState(
        isSelect: Map.from(isSelect),
        selectedTemplate: existingTemplate ?? list[0],
        type: _type,
      ));
    }
  }

  void select(DatabaseTemplate template, bool type) {
    isSelect.clear();
    final list = _list;
    _type = type;
    for (int i = 0; i < list.length; i++) {
      list[i] == template
          ? isSelect.addAll({list[i]: true})
          : isSelect.addAll({list[i]: false});
    }
    emit(TemplateSelectionState(
      isSelect: isSelect,
      selectedTemplate: template,
      type: type,
    ));
  }

  void selectFromAccount(String name, int value) async {
    final user = accountService.getCurrentUserOrThrow();

    final list = await accountService.getAllTemplate(userId: user.id);
    if (list.isEmpty) {
      return;
    }
    bool hasFound = false;

    for (int i = 0; i < list.length; i++) {
      if (list[i].name == name) {
        hasFound = true;
        existingTemplate = list[i];
        changeType(list[i].type);
        return;
      }
    }
    if (!hasFound) {
      final template = await accountService.createTemplate(
        name: name,
        userId: user.id,
        type: value > 0 ? true : false,
      );
      changeType(value > 0 ? true : false);
      existingTemplate = template;
    }
  }

  void changeType(bool newType) {
    _type = newType;
    emit(TemplateSelectionState(
      isSelect: isSelect,
      selectedTemplate:
          existingTemplate ?? (_list.isNotEmpty ? _list[0] : null),
      type: _type,
    ));
  }

  void clearSelect() {
    isSelect.clear();
    existingTemplate = null;
    emit(TemplateSelectionState(
        isSelect: isSelect,
        selectedTemplate: existingTemplate ?? _list[0],
        type: _type));
  }
}
