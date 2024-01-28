import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'dart:developer' as devtool show log;
import 'package:usefulmoney/services/routing/bloc/navigation_bar_route_bloc.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_route_event.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_route_state.dart';

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
    final items = (BuildContext context) => [
          BottomNavigationBarItem(
            label: '1',
            icon: Icon(context.platformIcons.flag),
          ),
          BottomNavigationBarItem(
            label: '2',
            icon: Icon(context.platformIcons.book),
          ),
        ];
    return BlocConsumer<NavigationBarRouteBloc, NavigationBarRouteState>(
      listener: (context, state) {},
      builder: (context, state) {
        return PlatformTabScaffold(
          appBarBuilder: (context, index) =>
              PlatformAppBar(title: PlatformText('Hello')),
          tabController: _tabController,
          bodyBuilder: (context, index) {
            return [
              Center(
                child: PlatformTextButton(
                  onPressed: () {},
                  child: PlatformText('1'),
                ),
              ),
              Center(
                child: PlatformTextButton(
                  onPressed: () {},
                  child: PlatformText('2'),
                ),
              ),
            ][state.index];
          },
          items: items(context),
          itemChanged: (index) {
            context.read<NavigationBarRouteBloc>().add(
                NavigationBarRouteEventGoTo(
                    context: context,
                    index: index,
                    controller: _tabController));
          },
        );
      },
    );
  }
}
