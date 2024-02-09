import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_bloc.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_event.dart';
import 'package:usefulmoney/domain/interface_operation/bloc/ui_state.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/type/database_book.dart';

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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) =>
                            widget.onDelete(widget.accounts[index]),
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                      )
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: Text(
                        widget.accounts[index].accountName,
                      ),
                      trailing: Text(widget.accounts[index].value.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: widget.accounts[index].value > 0
                                  ? Colors.green
                                  : Colors.red)),
                      onTap: () => widget.onTap(widget.accounts[index]),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return ListView.builder(
            itemCount: widget.accounts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: CheckboxListTile(
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
                    secondary: const Icon(Icons.attach_money),
                    subtitle: Text(widget.accounts[index].value.toString(),
                        style: TextStyle(
                            color: widget.accounts[index].value > 0
                                ? Colors.green
                                : Colors.red)),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
