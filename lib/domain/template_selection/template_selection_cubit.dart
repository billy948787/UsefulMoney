import 'package:bloc/bloc.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_state.dart';

class TemplateSelectionCubit extends Cubit<TemplateSelectionState> {
  TemplateSelectionCubit()
      : super(
            const TemplateSelectionState(isSelect: {}, selectedTemplate: null));
  List<DatabaseTemplate> _list = [];
  Map<DatabaseTemplate, bool> isSelect = {};
  DatabaseTemplate? existingTemplate;
  final AccountService accountService = AccountService();

  void init(List<DatabaseTemplate> list) async {
    _list = list;
    if (state.isSelect.isEmpty || state.isSelect.length != list.length) {
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
      emit(TemplateSelectionState(
          isSelect: isSelect, selectedTemplate: existingTemplate ?? list[0]));
    }
  }

  void select(DatabaseTemplate template) {
    isSelect.clear();
    final list = _list;
    for (int i = 0; i < list.length; i++) {
      list[i] == template
          ? isSelect.addAll({list[i]: true})
          : isSelect.addAll({list[i]: false});
    }
    emit(
        TemplateSelectionState(isSelect: isSelect, selectedTemplate: template));
  }

  void selectFromAccount(String name) async {
    final user = accountService.getCurrentUserOrThrow();

    final list = await accountService.getAllTemplate(userId: user.id);
    bool hasFound = false;

    for (int i = 0; i < list.length; i++) {
      if (list[i].name == name) {
        hasFound = true;
        existingTemplate = list[i];
      }
    }
    if (!hasFound) {
      final template =
          await accountService.createTemplate(name: name, userId: user.id);
      existingTemplate = template;
    }
  }

  void clearSelect() {
    isSelect.clear();
    existingTemplate = null;
  }
}
