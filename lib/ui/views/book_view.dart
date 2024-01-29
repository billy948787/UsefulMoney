import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/business_logic/constant/route.dart';
import 'package:usefulmoney/business_logic/services/data/account_service.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_event.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_state.dart';
import 'dart:developer' as devtool show log;

import 'package:usefulmoney/ui/views/account/account_list_view.dart';
import 'package:usefulmoney/utililties/dialogs/delete_dialog.dart';

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
        children: [
          PlatformAppBar(
            trailingActions: [
              PlatformIconButton(
                icon: Icon(context.platformIcons.add),
                onPressed: () {
                  final state = context.read<DataBloc>().state;
                  devtool.log(state.toString());
                  context
                      .read<DataBloc>()
                      .add(const DataEventNewOrUpdateAccount());
                },
              ),
            ],
          ),
          SizedBox(
            height: 200,
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
                  );
                } else {
                  return PlatformCircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
