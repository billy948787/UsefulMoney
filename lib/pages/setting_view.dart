import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_state.dart';
import 'package:usefulmoney/utils/dialogs/reset_dialog.dart';
import 'package:usefulmoney/widgets/settings/reset_button.dart';
import 'package:usefulmoney/widgets/settings/send_bug_button.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataBloc, DataState>(
      listener: (context, state) async {
        if (state is DataStateResetDatabase && state.needReset) {
          final wantReset = await showResetDialog(context: context);
          if (wantReset && context.mounted) {
            context
                .read<DataBloc>()
                .add(const DataEventResetDatabase(wantReset: true));
          } else if (context.mounted) {
            context
                .read<DataBloc>()
                .add(const DataEventResetDatabase(wantReset: false));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            children: [
              const ResetButton(),
              const SendBugButton(),
            ],
          ),
        ),
      ),
    );
  }
}
