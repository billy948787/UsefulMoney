import 'dart:io';
import 'dart:typed_data';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';

class EmailService {
  final smtpServer = SmtpServer(
    'smtp.gmail.com',
    port: 465,
    ssl: true,
    name: 'billy',
    username: 'billy948787',
    password: 'sdrr cfxm bhjq yshj',
  );

  static final EmailService _shared = EmailService._internal();

  EmailService._internal();

  factory EmailService() => _shared;

  Future<void> sendMessage({
    required String subject,
    required String text,
    required Uint8List imageByte,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(imageByte);
    final message = Message()
      ..from = const Address('billy948787@gmail.com')
      ..recipients.add(const Address('billy948787@gmail.com'))
      ..attachments = [FileAttachment(file)]
      ..subject = subject
      ..text = text;

    await send(message, smtpServer);
  }
}
