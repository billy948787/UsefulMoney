import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'dart:developer' as devtool show log;
import 'package:usefulmoney/services/routing/bloc/navigation_bar_bloc.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_event.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_state.dart';
import 'package:usefulmoney/views/book_view.dart';

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
    return BlocConsumer<NavigationBarBloc, NavigationBarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PlatformTabScaffold(
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
            ][state.index];
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
            context.read<NavigationBarBloc>().add(NavigationBarEventGoTo(
                context: context, index: index, controller: _tabController));
          },
        );
      },
    );
  }
}
