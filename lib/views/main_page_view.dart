import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/constant/route.dart';
import 'package:usefulmoney/services/data/account_service.dart';
import 'package:usefulmoney/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/services/data/bloc/data_state.dart';
import 'dart:developer' as devtool show log;
import 'package:usefulmoney/services/routing/navigation_bar_cubit.dart';
import 'package:usefulmoney/utils/dialogs/error_dialog.dart';
import 'package:usefulmoney/views/add_account_view.dart';
import 'package:usefulmoney/views/book_view.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  late final PlatformTabController _tabController;
  late final AccountService _accountService;

  @override
  void initState() {
    _accountService = AccountService();
    _tabController = PlatformTabController(initialIndex: 0);
    _accountService.open();
    super.initState();
  }

  @override
  void dispose() {
    _accountService.close();
    _tabController.dispose();
    super.dispose();
  }

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
        if (state is DataStateAddedNewAccount) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, addNewAccountRoute);
          }
        }
      },
      child: PlatformTabScaffold(
        tabController: _tabController,
        bodyBuilder: (context, index) {
          return [
            const BookView(),
            Center(
              child: PlatformTextButton(
                onPressed: () {},
                child: PlatformText('2'),
              ),
            ),
          ][index];
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(context.platformIcons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(context.platformIcons.wifi),
          ),
        ],
        itemChanged: (index) {
          context.read<NavigationBarCubit>().changeIndex(
                context: context,
                controller: _tabController,
                target: index,
              );
        },
      ),
    );
  }
}
