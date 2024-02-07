import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/type/database_book.dart';
import 'package:usefulmoney/domain/template_selection/template_selection_cubit.dart';
import 'package:usefulmoney/routes/route.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_bloc.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_event.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_state.dart';
import 'package:usefulmoney/domain/services/counting/bloc/couter_cubit.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'package:usefulmoney/widgets/account/account_list_widget.dart';
import 'package:usefulmoney/widgets/dialogs/delete_dialog.dart';

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterCubit>().clear();
          context.read<TemplateSelectionCubit>().changeType(false);
          context.read<DataBloc>().add(const DataEventNewOrUpdateAccount());
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
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
                            const DataEventDeleteListAccount(wantDelete: true));
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
      body: BlocListener<DataBloc, DataState>(
        listener: (context, state) async {
          if (state is DataStateDelete) {
            final wantDelete = await showDeleteDialog(context);
            if (wantDelete) {
              if (context.mounted) {
                context.read<DataBloc>().add(
                    DataEventDeleteAccount(id: state.id, wantDelete: true));
              }
            } else {
              if (context.mounted) {
                context.read<DataBloc>().add(
                    DataEventDeleteAccount(id: state.id, wantDelete: false));
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
                        stream: _accountService.balance,
                        builder: (context, snapshot) {
                          final value = snapshot.data;
                          if (snapshot.hasData) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(fontSize: cardFontSize),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('left'),
                          const Text('right'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _accountService.allAccounts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final accounts = snapshot.data as List<DatabaseBook>;
                    return AccountListView(
                      accounts: accounts.reversed.toList(),
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
                            .read<TemplateSelectionCubit>()
                            .selectFromAccount(
                              account.accountName,
                              account.value,
                            );
                        context.read<CounterCubit>().clear();
                        context
                            .read<CounterCubit>()
                            .add(account.value.toString());
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
                      isSelected: List.generate(
                          snapshot.data!.length, (index) => false),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const cardFontSize = 30.0;
