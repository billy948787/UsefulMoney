import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/constant/route.dart';
import 'package:usefulmoney/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/services/data/bloc/data_event.dart';
import 'package:usefulmoney/services/data/bloc/data_state.dart';
import 'dart:developer' as devtool show log;

class AddAccountView extends StatefulWidget {
  const AddAccountView({super.key});

  @override
  State<AddAccountView> createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DataBloc, DataState>(
      listener: (context, state) {
        if (state is DataStateHome) {
          Navigator.of(context).pushReplacementNamed(homeRoute);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            PlatformIconButton(
              icon: Icon(context.platformIcons.clear),
              onPressed: () {
                final state = context.read<DataBloc>().state;
                devtool.log(state.toString());
                context.read<DataBloc>().add(const DataEventNewAccount(
                      needGoBack: true,
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
