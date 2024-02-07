import 'package:equatable/equatable.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';

class TemplateSelectionState extends Equatable {
  final Map<DatabaseTemplate, bool> isSelect;
  final DatabaseTemplate? selectedTemplate;
  final bool type;

  const TemplateSelectionState({
    required this.isSelect,
    required this.selectedTemplate,
    required this.type,
  });

  @override
  List<Object?> get props => [isSelect, selectedTemplate, type];
}
