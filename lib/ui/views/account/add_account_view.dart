import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/business_logic/constant/route.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_event.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_state.dart';
import 'package:usefulmoney/business_logic/services/data/type/database_book.dart';
import 'dart:developer' as devtool show log;

import 'package:usefulmoney/utililties/dialogs/error_dialog.dart';

class AddAccountView extends StatefulWidget {
  const AddAccountView({super.key});

  @override
  State<AddAccountView> createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  late final TextEditingController _name;
  late final TextEditingController _value;

  @override
  void initState() {
    _name = TextEditingController();
    _value = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseBook? account =
        ModalRoute.of(context)!.settings.arguments as DatabaseBook?;
    if (account != null) {
      _name.text = account.accountName;
      _value.text = account.value.toString();
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
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: PlatformIconButton(
                icon: Icon(context.platformIcons.clear),
                onPressed: () {
                  final state = context.read<DataBloc>().state;
                  devtool.log(state.toString());
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
            PlatformTextField(
              controller: _name,
              keyboardType: TextInputType.name,
              hintText: 'Name',
            ),
            PlatformTextField(
              controller: _value,
              keyboardType: TextInputType.number,
              hintText: 'Value',
            ),
            PlatformIconButton(
              icon: Icon(context.platformIcons.add),
              onPressed: () {
                final name = _name.text;
                final value = _value.text;
                if (account != null) {
                  context.read<DataBloc>().add(DataEventNewOrUpdateAccount(
                        name: name,
                        value: value,
                        needGoBack: true,
                        isAdded: true,
                        account: account,
                      ));
                } else {
                  context.read<DataBloc>().add(DataEventNewOrUpdateAccount(
                        name: name,
                        value: value,
                        needGoBack: true,
                        isAdded: true,
                      ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
