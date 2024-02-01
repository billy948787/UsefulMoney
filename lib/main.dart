import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/business_logic/constant/data_constant.dart';
import 'package:usefulmoney/business_logic/constant/route.dart';
import 'package:usefulmoney/business_logic/interface_operation/bloc/ui_bloc.dart';
import 'package:usefulmoney/business_logic/services/counting/bloc/couter_cubit.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/business_logic/services/data/bloc/data_event.dart';
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
  late final DataBloc dataBloc;
  late final UiBloc uiBloc;
  late final CounterCubit counterCubit;

  @override
  void initState() {
    dataBloc = DataBloc(defaultEmail);
    uiBloc = UiBloc();
    counterCubit = CounterCubit('');
    dataBloc.add(const DataEventCreateOrGetUser());
    dataBloc.add(const DataEventOpenDatabase());
    super.initState();
  }

  @override
  void dispose() {
    uiBloc.close();
    dataBloc.add(const DataEventCloseDatabase());
    dataBloc.close();
    counterCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      title: 'UsefulMoney',
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
      ],
      color: Colors.grey,
      routes: {
        addNewAccountRoute: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: dataBloc),
                BlocProvider.value(value: uiBloc),
                BlocProvider.value(value: counterCubit),
              ],
              child: const AddAccountView(),
            ),
        homeRoute: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: dataBloc),
                BlocProvider.value(value: uiBloc),
                BlocProvider.value(value: counterCubit),
              ],
              child: const MainPageView(),
            ),
      },
    );
  }
}
