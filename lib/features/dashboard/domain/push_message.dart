class PushMessage 
{
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final bool read;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    this.read = false,
  });

  PushMessage copyWith({bool? read}) => PushMessage(
    messageId: messageId,
    title: title,
    body: body,
    sentDate: sentDate,
    read: read ?? this.read,
  );

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'title': title,
      'body': body,
      'sentDate': sentDate.toIso8601String(),
      'read': read ? 1 : 0,
    };
  }

  static PushMessage fromMap(Map<String, dynamic> map) {
    final rawDate = map['sentDate'];
    DateTime parsedDate;

    if (rawDate == null || rawDate.toString().isEmpty) {
      parsedDate = DateTime.now();
    } else {
      try {
        parsedDate = DateTime.parse(rawDate);
      } catch (_) {
        parsedDate = DateTime.now();
      }
    }

    return PushMessage(
      messageId: map['messageId'],
      title: map['title'],
      body: map['body'],
      sentDate: parsedDate,
      read: map['read'] == 1,
    );
  }

}
