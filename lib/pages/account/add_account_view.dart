import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/type/database_template.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_cubit.dart';
import 'package:usefulmoney/pages/account/template_views/add_update_template_view.dart';
import 'package:usefulmoney/pages/account/template_views/template_grid_view.dart';
import 'package:usefulmoney/routes/route.dart';
import 'package:usefulmoney/domain/services/counting/bloc/couter_cubit.dart';
import 'package:usefulmoney/domain/services/counting/bloc/couter_state.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'package:usefulmoney/domain/services/data/type/database_book.dart';
import 'package:usefulmoney/utils/enums/template_actions.dart';
import 'package:usefulmoney/widgets/buttons/custom_text_botton.dart';
import 'package:usefulmoney/widgets/dialogs/template_action_dialog.dart';
import 'package:usefulmoney/widgets/numpad.dart';
import 'package:usefulmoney/widgets/dialogs/error_dialog.dart';

class AddAccountView extends StatefulWidget {
  const AddAccountView({super.key});

  @override
  State<AddAccountView> createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  final AccountService _accountService = AccountService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseBook? account =
        ModalRoute.of(context)!.settings.arguments as DatabaseBook?;
    return BlocListener<DataBloc, DataState>(
      listener: (context, state) async {
        if (state is DataStateHome) {
          Navigator.of(context).pushReplacementNamed(homeRoute);
        }
        if (state.exception != null) {
          await showErrorDialog(
            title: 'Error',
            content: state.exception.toString(),
            context: context,
          );
        }
        if (state is DataStateAddedOrUpdatedNewTemplate &&
            state.needPushOrPop) {
          if (context.mounted) {
            await showDialog(
                context: context,
                builder: (_) {
                  if (state.template != null) {
                    return BlocProvider.value(
                      value: context.read<DataBloc>(),
                      child: AddUpdateTemplateView(template: state.template),
                    );
                  } else {
                    return BlocProvider.value(
                      value: context.read<DataBloc>(),
                      child: const AddUpdateTemplateView(),
                    );
                  }
                });
          }
        }
        if (state is DataStateChooseTemplateAction) {
          if (!state.hasChoosed) {
            final id = state.id;
            if (context.mounted) {
              final action = await showDialog<TemplateActions>(
                context: context,
                builder: (context) => const TemplateActionDialog(),
              ).then((value) => value ?? TemplateActions.none);
              if (context.mounted) {
                context
                    .read<DataBloc>()
                    .add(DataEventChooseTemplateAction(action: action, id: id));
              }
            }
          }
        }
      },
      child: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        context.read<TemplateSelectionCubit>().clearSelect();
                        context
                            .read<DataBloc>()
                            .add(const DataEventNewOrUpdateAccount(
                              needGoBack: true,
                            ));
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: _accountService.allTemplates,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final list = snapshot.data as List<DatabaseTemplate>;
                          context.read<TemplateSelectionCubit>().init(list);
                          final templates = list
                              .map((element) => CustomTextButton(
                                    onPress: () {
                                      setState(() {
                                        context
                                            .read<TemplateSelectionCubit>()
                                            .select(element);
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
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        state.value,
                        style: const TextStyle(fontSize: 30),
                      )),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final value = state.value;
                      final name = context
                          .read<TemplateSelectionCubit>()
                          .state
                          .selectedTemplate!
                          .name;
                      if (account != null) {
                        context
                            .read<DataBloc>()
                            .add(DataEventNewOrUpdateAccount(
                              name: name,
                              value: value,
                              needGoBack: true,
                              isAdded: true,
                              account: account,
                            ));
                      } else {
                        context
                            .read<DataBloc>()
                            .add(DataEventNewOrUpdateAccount(
                              name: name,
                              value: value,
                              needGoBack: true,
                              isAdded: true,
                            ));
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Numpad(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
