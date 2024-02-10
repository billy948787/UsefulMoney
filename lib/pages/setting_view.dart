import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_bloc.dart';
import 'package:usefulmoney/domain/services/data/bloc/data_event.dart';
import 'package:usefulmoney/widgets/buttons/custom_botton.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          children: [
            CustomBotton(
              onClick: () {
                context.read<DataBloc>().add(const DataEventResetDatabase());
              },
              content: '重置資料(無法復原)',
              icon: const Icon(Icons.replay_outlined),
            ),
            CustomBotton(
              onClick: () {
                BetterFeedback.of(context).show(
                  (UserFeedback feedback) async {
                    final path = await getApplicationCacheDirectory();

                    final email = Message()
                      ..from = Address('billy948787@gmail.com', ['unknown'])
                      ..recipients.add('billy948787@gmail.com')
                      ..subject = 'UserfulMoney bug found'
                      ..text = feedback.text
                      ..attachments = [
                        FileAttachment(File.fromRawPath(feedback.screenshot))
                          ..location = Location.attachment
                      ];
                  },
                );
              },
              content: '有錯誤？ 按這來傳送給我！',
              icon: const Icon(Icons.bug_report),
            )
          ],
        ),
      ),
    );
  }
}
