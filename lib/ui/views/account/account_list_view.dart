import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/business_logic/interface_operation/bloc/ui_bloc.dart';
import 'package:usefulmoney/business_logic/interface_operation/bloc/ui_event.dart';
import 'package:usefulmoney/business_logic/interface_operation/bloc/ui_state.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_event.dart';
import 'package:usefulmoney/business_logic/services/data/type/database_book.dart';
import 'dart:developer' as devtool show log;

import 'package:usefulmoney/utililties/dialogs/delete_dialog.dart';

typedef DeleteCallBack = void Function(DatabaseBook);
typedef OnTapCallBack = void Function(DatabaseBook);

class AccountListView extends StatefulWidget {
  const AccountListView({
    super.key,
    required this.accounts,
    required this.onDelete,
    required this.deleteInstantly,
    required this.onTap,
    required this.isSelected,
  });
  final List<DatabaseBook> accounts;
  final DeleteCallBack onDelete;
  final OnTapCallBack onTap;
  final DeleteCallBack deleteInstantly;
  final List<bool> isSelected;
  @override
  State<AccountListView> createState() => _AccountListViewState();
}

class _AccountListViewState extends State<AccountListView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UiBloc, UiState>(
      listener: (context, state) {
        if (state is UiStateDeleteAllAccount) {
          for (int i = 0; i < widget.isSelected.length; i++) {
            widget.isSelected[i] = true;
          }
          context.read<DataBloc>().add(DataEventDeleteListAccount(
              accounts: widget.accounts, needAddtoListOrRemove: true));
          context
              .read<UiBloc>()
              .add(const UiEventDeleteAccounts(cancel: false));
        }
        if (state is UiStateCancelAllAccount) {
          for (int i = 0; i < widget.isSelected.length; i++) {
            widget.isSelected[i] = false;
          }
          context.read<DataBloc>().add(DataEventDeleteListAccount(
              accounts: widget.accounts, needAddtoListOrRemove: false));
          context.read<UiBloc>().add(const UiEventDeleteAccounts(
                cancel: true,
              ));
        }
      },
      builder: (context, state) {
        if (state is UiStateHome) {
          return ListView.builder(
            itemCount: widget.accounts.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(widget.accounts[index].accountName),
                onDismissed: (direction) =>
                    widget.deleteInstantly(widget.accounts[index]),
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: const BoxDecoration(color: Colors.red),
                  alignment: Alignment.centerRight,
                  child:
                      Icon(context.platformIcons.delete, color: Colors.black),
                ),
                confirmDismiss: (direction) {
                  return showDeleteDialog(context);
                },
                child: PlatformListTile(
                  title: Text(
                    widget.accounts[index].accountName,
                  ),
                  subtitle: Text(widget.accounts[index].value.toString()),
                  onTap: () => widget.onTap(widget.accounts[index]),
                ),
              );
            },
          );
        } else {
          return ListView.builder(
            itemCount: widget.accounts.length,
            itemBuilder: (context, index) {
              return CheckboxListTile.adaptive(
                value: widget.isSelected[index],
                onChanged: (value) {
                  setState(() {
                    widget.isSelected[index] = value!;
                    context.read<DataBloc>().add(DataEventDeleteListAccount(
                        id: widget.accounts[index].id,
                        needAddtoListOrRemove: value));
                  });
                },
                title: Text(
                  widget.accounts[index].accountName,
                ),
                subtitle: Text(widget.accounts[index].value.toString()),
              );
            },
          );
        }
      },
    );
  }
}
