import 'package:equatable/equatable.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';

class TemplateSelectionState extends Equatable {
  final Map<DatabaseTemplate, bool> isSelect;
  final DatabaseTemplate? selectedTemplate;

  const TemplateSelectionState(
      {required this.isSelect, required this.selectedTemplate});

  @override
  List<Object?> get props => [isSelect, selectedTemplate];
}
