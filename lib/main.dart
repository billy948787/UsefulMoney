import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/constant/route.dart';
import 'package:usefulmoney/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_bloc.dart';
import 'package:usefulmoney/views/add_account_view.dart';
import 'package:usefulmoney/views/main_page_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PlatformProvider(
    builder: (context) => PlatformApp(
      title: 'Flutter Demo',
      color: Colors.grey,
      routes: {
        addNewAccountRoute: (context) => const AddAccountView(),
      },
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavigationBarBloc(),
          ),
          BlocProvider(
            create: (context) => DataBloc(),
          ),
        ],
        child: const MainPageView(),
      ),
    ),
  ));
}
