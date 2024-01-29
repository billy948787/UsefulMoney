import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/services/data/account_service.dart';

typedef DeleteCallBack = void Function(DatabaseBook);
typedef OnTapCallBack = void Function(DatabaseBook);

class AccountListView extends StatelessWidget {
  const AccountListView(
      {super.key, required this.accounts, required this.onDelete, this.onTap});
  final List<DatabaseBook> accounts;
  final DeleteCallBack onDelete;
  final OnTapCallBack? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        return PlatformListTile(
          title: PlatformText(accounts[index].accountName),
        );
      },
    );
  }
}
