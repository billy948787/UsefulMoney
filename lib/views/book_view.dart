import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:usefulmoney/constant/route.dart';
import 'package:usefulmoney/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/services/data/bloc/data_event.dart';
import 'package:usefulmoney/services/data/bloc/data_state.dart';
import 'package:usefulmoney/utils/dialogs/error_dialog.dart';

class BookView extends StatefulWidget {
  const BookView({super.key});

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
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
        if (state is DataStateAddedNewAccount && state.needPop) {
          if (context.mounted) {
            Navigator.of(context).pushNamed(addNewAccountRoute);
          }
        }
      },
      child: Column(
        children: [
          PlatformAppBar(
            trailingActions: [
              PlatformIconButton(
                icon: Icon(context.platformIcons.add),
                onPressed: () {
                  context
                      .read<DataBloc>()
                      .add(const DataEventNewAccount(needGoBack: false));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
