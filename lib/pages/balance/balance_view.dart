import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/account_service.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';

class BalanceView extends StatefulWidget {
  const BalanceView({super.key});

  @override
  State<BalanceView> createState() => _BalanceViewState();
}

class _BalanceViewState extends State<BalanceView> {
  late final AccountService _accountService;

  @override
  void initState() {
    _accountService = AccountService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataBloc, DataState>(
      listener: (context, state) {},
      child: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          StreamBuilder(
            stream: _accountService.balance,
            builder: (context, snapshot) {
              final value = snapshot.data;
              if (snapshot.hasData) {
                return Text(value.toString());
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          TextButton(
            onPressed: () {
              context.read<DataBloc>().add(const DataEventResetUser());
            },
            child: const Text('reset'),
          ),
        ],
      ),
    );
  }
}
