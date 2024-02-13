import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/widgets/buttons/custom_botton.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBotton(
      onClick: () {
        context
            .read<DataBloc>()
            .add(const DataEventResetDatabase(wantReset: null));
      },
      content: '重置資料(無法復原)',
      icon: const Icon(Icons.replay_outlined),
    );
  }
}
