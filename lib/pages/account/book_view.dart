import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/routes/route.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_bloc.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_event.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_state.dart';
import 'package:usefulmoney/domain/services/counting/bloc/couter_cubit.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'dart:developer' as devtool show log;

import 'package:usefulmoney/pages/account/account_list_view.dart';
import 'package:usefulmoney/utils/dialogs/delete_dialog.dart';

class BookView extends StatefulWidget {
  const BookView({super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  late final AccountService _accountService;

  @override
  void initState() {
    _accountService = AccountService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataBloc, DataState>(
      listener: (context, state) async {
        if (state is DataStateDelete) {
          final wantDelete = await showDeleteDialog(context);
          if (wantDelete) {
            if (context.mounted) {
              context
                  .read<DataBloc>()
                  .add(DataEventDeleteAccount(id: state.id, wantDelete: true));
            }
          } else {
            if (context.mounted) {
              context
                  .read<DataBloc>()
                  .add(DataEventDeleteAccount(id: state.id, wantDelete: false));
            }
          }
        }
        if (state is DataStateAddedOrUpdatedNewAccount) {
          if (context.mounted) {
            if (state.account != null) {
              Navigator.pushReplacementNamed(
                context,
                addNewAccountRoute,
                arguments: state.account,
              );
            } else {
              Navigator.pushReplacementNamed(
                context,
                addNewAccountRoute,
              );
            }
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            actions: [
              BlocBuilder<UiBloc, UiState>(
                builder: (context, state) {
                  if (state is UiStateHome) {
                    return TextButton(
                      onPressed: () => context.read<UiBloc>().add(
                            const UiEventDeleteAccounts(cancel: false),
                          ),
                      child: const Text('Delete'),
                    );
                  } else {
                    return Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<UiBloc>()
                                .add(const UiEventDeselectAllAccount());
                            context.read<UiBloc>().add(
                                  const UiEventDeleteAccounts(cancel: true),
                                );
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<DataBloc>().add(
                                const DataEventDeleteListAccount(
                                    wantDelete: true));
                            context
                                .read<UiBloc>()
                                .add(const UiEventDeleteAccounts(cancel: true));
                          },
                          child: const Text('Confirm'),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<UiBloc>()
                                .add(const UiEventSelectAllAccountsToDelete());
                          },
                          child: const Text('Select all'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: _accountService.allAccounts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AccountListView(
                    accounts: snapshot.data!,
                    onDelete: (account) {
                      context.read<DataBloc>().add(
                            DataEventDeleteAccount(
                              id: account.id,
                              wantDelete: null,
                            ),
                          );
                    },
                    onTap: (account) {
                      context
                          .read<DataBloc>()
                          .add(DataEventNewOrUpdateAccount(account: account));
                    },
                    deleteInstantly: (account) {
                      context.read<DataBloc>().add(DataEventDeleteAccount(
                            id: account.id,
                            wantDelete: true,
                          ));
                    },
                    isSelected:
                        List.generate(snapshot.data!.length, (index) => false),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  final state = context.read<DataBloc>().state;
                  devtool.log(state.toString());
                  context.read<CounterCubit>().clear();
                  context
                      .read<DataBloc>()
                      .add(const DataEventNewOrUpdateAccount());
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}
