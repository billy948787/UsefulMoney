import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/business_logic/constant/data_constant.dart';
import 'package:usefulmoney/business_logic/constant/route.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_event.dart';
import 'package:usefulmoney/business_logic/services/routing/navigation_bar_cubit.dart';
import 'package:usefulmoney/ui/views/account/add_account_view.dart';
import 'package:usefulmoney/ui/views/main_page_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final NavigationBarCubit cubit;
  late final DataBloc dataBloc;

  @override
  void initState() {
    cubit = NavigationBarCubit(0);
    dataBloc = DataBloc(defaultEmail);
    dataBloc.add(const DataEventCreateOrGetUser());
    dataBloc.add(const DataEventOpenDatabase());
    super.initState();
  }

  @override
  void dispose() {
    dataBloc.add(const DataEventCloseDatabase());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      builder: (context) {
        return PlatformApp(
          title: 'Flutter Demo',
          color: Colors.grey,
          routes: {
            addNewAccountRoute: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: cubit),
                    BlocProvider.value(value: dataBloc),
                  ],
                  child: const AddAccountView(),
                ),
            homeRoute: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: cubit),
                    BlocProvider.value(value: dataBloc),
                  ],
                  child: const MainPageView(),
                ),
          },
        );
      },
      initialPlatform: TargetPlatform.android,
    );
  }
}
