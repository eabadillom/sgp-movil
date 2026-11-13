import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';

PushMessage pushMessageFromRemoteMessage(RemoteMessage message) 
{
  final data = message.data;
  final notificationTitle = message.notification?.title;
  final notificationBody = message.notification?.body;

  return PushMessage(
    messageId: _messageIdFor(message),
    title: notificationTitle != null && notificationTitle.isNotEmpty ? notificationTitle : data['title']?.toString() ?? '',
    body: notificationBody != null && notificationBody.isNotEmpty ? notificationBody : data['body']?.toString() ?? '',
    sentDate: message.sentTime ?? DateTime.now(),
  );
}

String _messageIdFor(RemoteMessage message) 
{
  final messageId = message.messageId;
  if (messageId != null && messageId.trim().isNotEmpty) {
    return messageId;
  }

  final payloadId = message.data['messageId'] ?? message.data['id'];
  if (payloadId != null && payloadId.toString().trim().isNotEmpty) {
    return payloadId.toString();
  }

  return _fallbackMessageId(message);
}

String _fallbackMessageId(RemoteMessage message)
{
  final dataEntries = message.data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final fingerprintSource = jsonEncode({
    'sentTime': message.sentTime?.toUtc().toIso8601String(),
    'title': message.notification?.title ?? message.data['title']?.toString() ?? '',
    'body': message.notification?.body ?? message.data['body']?.toString() ?? '',
    'data': dataEntries.map((entry) => [entry.key, entry.value]).toList(),
  });

  var fnvHash = 0x811c9dc5;
  var djbHash = 5381;
  for (final codeUnit in fingerprintSource.codeUnits) {
    fnvHash = ((fnvHash ^ codeUnit) * 0x01000193) & 0xffffffff;
    djbHash = ((djbHash * 33) ^ codeUnit) & 0xffffffff;
  }

  final fnvPart = fnvHash.toRadixString(16).padLeft(8, '0');
  final djbPart = djbHash.toRadixString(16).padLeft(8, '0');
  return 'local-$fnvPart$djbPart';
}
