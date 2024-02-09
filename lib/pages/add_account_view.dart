import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_cubit.dart';
import 'package:usefulmoney/widgets/template_views/add_update_template_view.dart';
import 'package:usefulmoney/widgets/switch/custom_switch.dart';
import 'package:usefulmoney/widgets/templates.dart';
import 'package:usefulmoney/routes/route.dart';
import 'package:usefulmoney/domain/services/counting/bloc/couter_cubit.dart';
import 'package:usefulmoney/domain/services/counting/bloc/couter_state.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'package:usefulmoney/domain/services/data/type/database_book.dart';
import 'package:usefulmoney/utils/enums/template_actions.dart';
import 'package:usefulmoney/widgets/dialogs/template_action_dialog.dart';
import 'package:usefulmoney/widgets/numpad.dart';
import 'package:usefulmoney/widgets/dialogs/error_dialog.dart';
import 'dart:developer' as devtool show log;

class AddAccountView extends StatefulWidget {
  const AddAccountView({super.key});

  @override
  State<AddAccountView> createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  @override
  Widget build(BuildContext context) {
    bool isActive = false;
    final DatabaseBook? account =
        ModalRoute.of(context)!.settings.arguments as DatabaseBook?;
    if (account != null) {
      isActive = account.value > 0 ? true : false;
    }
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
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<DataBloc>(),
                          ),
                          BlocProvider.value(
                              value: context.read<TemplateSelectionCubit>()),
                        ],
                        child: AddUpdateTemplateView(template: state.template),
                      );
                    } else {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<DataBloc>(),
                          ),
                          BlocProvider.value(
                              value: context.read<TemplateSelectionCubit>())
                        ],
                        child: const AddUpdateTemplateView(),
                      );
                    }
                  }).then((value) {
                if (value == null) {
                  context.read<DataBloc>().add(
                      const DataEventNewOrUpdateAccount(
                          needGoBack: false, isAdded: false));
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
                  context.read<DataBloc>().add(
                      DataEventChooseTemplateAction(action: action, id: id));
                }
              }
            }
          }
        },
        child: Scaffold(
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
                      devtool.log(
                          'sent ${context.read<TemplateSelectionCubit>().state.isSelect.toString()}');
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
                const Templates(),
                Align(
                    alignment: Alignment.centerRight,
                    child: BlocBuilder<CounterCubit, CounterState>(
                      builder: (context, state) {
                        return Text(
                          state.value,
                          style: const TextStyle(fontSize: 30),
                        );
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomSwitch(
                        inactiveAction: () {
                          isActive = false;
                        },
                        activeAction: () {
                          isActive = true;
                        },
                        initValue: isActive,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final value =
                              context.read<CounterCubit>().state.value;
                          devtool.log(context
                              .read<TemplateSelectionCubit>()
                              .state
                              .selectedTemplate
                              .toString());
                          final name = context
                              .read<TemplateSelectionCubit>()
                              .state
                              .selectedTemplate!
                              .name;
                          devtool.log(name);
                          isActive
                              ? context
                                  .read<DataBloc>()
                                  .add(DataEventNewOrUpdateAccount(
                                    name: name,
                                    value: value,
                                    needGoBack: true,
                                    isAdded: true,
                                    account: account,
                                    isPositive: true,
                                  ))
                              : context.read<DataBloc>().add(
                                  DataEventNewOrUpdateAccount(
                                      name: name,
                                      value: value,
                                      needGoBack: true,
                                      isAdded: true,
                                      account: account,
                                      isPositive: false));
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            context.read<CounterCubit>().deleteLast();
                          },
                          icon: const Icon(Icons.backspace)),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Numpad(),
                ),
              ],
            ),
          ),
        ));
  }
}
