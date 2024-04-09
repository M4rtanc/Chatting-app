import 'package:chat_app/models/attachment.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:json_annotation/json_annotation.dart';

import '../shared/enums/message_type.dart';

part 'app_message.g.dart';

@JsonSerializable()
class AppMessage {
  const AppMessage({
    this.id = "",
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.chatGroupId,
    required this.type
  });

  final String id;
  final String content;
  final DateTime createdAt;
  final String userId;
  final String chatGroupId;
  final MessageType type;

  factory AppMessage.fromJson(Map<String, dynamic> json) =>
      _$AppMessageFromJson(json);

  Map<String, dynamic> toJson() => _$AppMessageToJson(this);
}
