import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'push_message.g.dart';

@HiveType(typeId: 0)
class PushMessage extends Equatable
{
  @HiveField(0)
  final String messageId;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String body;
  @HiveField(3)
  final DateTime sentDate;
  @HiveField(4)
  final Map<String, dynamic> data;
  @HiveField(5)
  final String? imageUrl;
  @HiveField(6)
  final bool read;

  const PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    required this.data,
    this.imageUrl,
    this.read = false,
  });

  PushMessage copyWith({bool? read}) => PushMessage(
    messageId: messageId,
    title: title,
    body: body,
    sentDate: sentDate,
    data: data,
    imageUrl: imageUrl,
    read: read ?? this.read,
  );
  
  @override
  List<Object?> get props => [messageId, title, body, sentDate, data, imageUrl, read];

}
