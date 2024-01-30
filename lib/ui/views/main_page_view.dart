import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_state.dart';
import 'dart:developer' as devtool show log;
import 'package:usefulmoney/business_logic/services/routing/navigation_bar_cubit.dart';
import 'package:usefulmoney/ui/views/balance/balance_view.dart';
import 'package:usefulmoney/utililties/dialogs/error_dialog.dart';
import 'package:usefulmoney/ui/views/account/book_view.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  late final PlatformTabController _tabController;

  @override
  void initState() {
    _tabController = PlatformTabController(initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
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
      },
      child: PlatformTabScaffold(
        tabController: _tabController,
        bodyBuilder: (context, index) {
          return [
            const BookView(),
            const BalanceView(),
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
