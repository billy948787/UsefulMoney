import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'package:usefulmoney/pages/setting_view.dart';
import 'package:usefulmoney/utils/dialogs/error_dialog.dart';
import 'package:usefulmoney/pages/book_view.dart';

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
            title: 'Error $state',
            content: state.exception.toString(),
            context: context,
          );
        }
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: '首頁'),
              NavigationDestination(icon: Icon(Icons.settings), label: '設定'),
            ],
            onDestinationSelected: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            selectedIndex: _currentIndex),
        body: [
          const BookView(),
          const SettingView(),
        ][_currentIndex],
      ),
    );
  }
}
