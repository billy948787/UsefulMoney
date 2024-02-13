import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:usefulmoney/domain/smtp/email_service.dart';
import 'package:usefulmoney/widgets/buttons/custom_botton.dart';

class SendBugButton extends StatelessWidget {
  const SendBugButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBotton(
      onClick: () {
        BetterFeedback.of(context).show(
          (UserFeedback feedback) async {
            final emailService = EmailService();

            await emailService.sendMessage(
                subject: 'UsefulMoneyBug!!',
                text: feedback.text,
                imageByte: feedback.screenshot);
          },
        );
      },
      content: '回報錯誤或建議',
      icon: const Icon(Icons.bug_report),
    );
  }
}
