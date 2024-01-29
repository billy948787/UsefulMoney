import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/constant/route.dart';
import 'package:usefulmoney/services/data/account_service.dart';
import 'package:usefulmoney/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/services/data/bloc/data_event.dart';
import 'package:usefulmoney/services/data/bloc/data_state.dart';
import 'package:usefulmoney/utils/dialogs/error_dialog.dart';
import 'dart:developer' as devtool show log;

import 'package:usefulmoney/views/account_list_view.dart';

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
    return Column(
      children: [
        PlatformAppBar(
          trailingActions: [
            PlatformIconButton(
              icon: Icon(context.platformIcons.add),
              onPressed: () {
                final state = context.read<DataBloc>().state;
                devtool.log(state.toString());
                context.read<DataBloc>().add(const DataEventNewAccount());
              },
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: StreamBuilder(
            stream: _accountService.allAccounts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AccountListView(
                  accounts: snapshot.data!,
                  onDelete: (account) {
                    _accountService.deleteAccount(id: account.id);
                  },
                );
              } else {
                return PlatformCircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}
