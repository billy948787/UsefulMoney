import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'dart:developer' as devtool show log;
import 'package:usefulmoney/pages/balance/balance_view.dart';
import 'package:usefulmoney/widgets/dialogs/error_dialog.dart';
import 'package:usefulmoney/pages/account/book_view.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataBloc, DataState>(
      listener: (context, state) async {
        if (state.exception != null) {
          await showErrorDialog(
            title: 'Error',
            content: state.exception.toString(),
            context: context,
          );
        }
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: ''),
              NavigationDestination(icon: Icon(Icons.wifi), label: ''),
            ],
            onDestinationSelected: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            selectedIndex: _currentIndex),
        body: [
          const BookView(),
          const BalanceView(),
        ][_currentIndex],
      ),
    );
  }
}
