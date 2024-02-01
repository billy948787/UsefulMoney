import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/business_logic/constant/route.dart';
import 'package:usefulmoney/business_logic/services/counting/bloc/couter_cubit.dart';
import 'package:usefulmoney/business_logic/services/counting/bloc/couter_state.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_event.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_state.dart';
import 'package:usefulmoney/business_logic/services/data/type/database_book.dart';
import 'package:usefulmoney/ui/widgets/numpad.dart';
import 'dart:developer' as devtool show log;

import 'package:usefulmoney/utililties/dialogs/error_dialog.dart';

class AddAccountView extends StatefulWidget {
  const AddAccountView({super.key});

  @override
  State<AddAccountView> createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  late final TextEditingController _name;

  @override
  void initState() {
    _name = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseBook? account =
        ModalRoute.of(context)!.settings.arguments as DatabaseBook?;
    if (account != null) {
      _name.text = account.accountName;
      context.read<CounterCubit>().clear();
      context.read<CounterCubit>().add(account.value.toString());
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
      child: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.clear),
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
                TextField(
                  controller: _name,
                  keyboardType: TextInputType.name,
                ),
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0)),
                            color: Colors.white,
                          ),
                          width: 250,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                state.value,
                                style: const TextStyle(fontSize: 30),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final name = _name.text;
                    final value = state.value;
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
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Numpad(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
