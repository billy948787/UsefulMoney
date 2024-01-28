import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/services/routing/bloc/navigation_bar_bloc.dart';
import 'package:usefulmoney/views/main_page_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PlatformProvider(
    builder: (context) => PlatformApp(
      title: 'Flutter Demo',
      color: Colors.grey,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavigationBarBloc(),
          ),
          BlocProvider(
            create: (context) => SubjectBloc()
          ),
        ],
        child: const MainPageView(),
      ),
    ),
  ));
}
