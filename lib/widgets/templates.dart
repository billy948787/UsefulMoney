import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_cubit.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_state.dart';
import 'package:usefulmoney/widgets/template_grid.dart';
import 'package:usefulmoney/widgets/buttons/custom_text_botton.dart';
import 'dart:developer' as devtool show log;

class Templates extends StatefulWidget {
  const Templates({super.key});

  @override
  State<Templates> createState() => _TemplatesState();
}

class _TemplatesState extends State<Templates> {
  late final AccountService _accountService;

  @override
  void initState() {
    _accountService = AccountService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<DatabaseTemplate>>(
        stream: _accountService.allTemplates,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            devtool.log('in the stream builder ${snapshot.data.toString()}');
            final allList = snapshot.data as List<DatabaseTemplate>;
            return BlocBuilder<TemplateSelectionCubit, TemplateSelectionState>(
              buildWhen: (previous, current) => previous.type != current.type,
              builder: (context, state) {
                final type = state.type;
                final list = List<DatabaseTemplate>.from(allList);
                list.removeWhere((element) => element.type != type);
                context.read<TemplateSelectionCubit>().init(list);
                final templates = list
                    .map((element) => CustomTextButton(
                          onPress: () {
                            setState(() {
                              context
                                  .read<TemplateSelectionCubit>()
                                  .select(element, element.type);
                            });
                          },
                          content: element.name,
                          onHold: () => context.read<DataBloc>().add(
                                DataEventChooseTemplateAction(
                                  action: null,
                                  id: element.id,
                                ),
                              ),
                          template: element,
                        ))
                    .toList();
                templates.add(CustomTextButton(
                  onPress: () {
                    context.read<DataBloc>().add(
                        const DataEventCreateOrUpdateTemplate(
                            needPushOrPop: true));
                  },
                  onHold: () {},
                  content: 'Add',
                  template: null,
                ));
                return TemplateGridView(templates: templates);
              },
            );
          } else {
            return TemplateGridView(
              templates: [
                CustomTextButton(
                  onPress: () {
                    context.read<DataBloc>().add(
                        const DataEventCreateOrUpdateTemplate(
                            needPushOrPop: true));
                  },
                  onHold: () {},
                  content: 'Add',
                  template: null,
                )
              ],
            );
          }
        },
      ),
    );
  }
}
