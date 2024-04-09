import 'package:chat_app/models/user_chat_group.dart';
import 'package:json_annotation/json_annotation.dart';

import '../shared/enums/chat_group_type.dart';
import 'app_message.dart';

part 'chat_group.g.dart';

@JsonSerializable()
class ChatGroup {
  const ChatGroup({
    this.id = "",
    required this.name,
    required this.description,
    this.imageUrl = "defaultImageUrl",
    required this.createdAt,
    required this.chatGroupType,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final ChatGroupType chatGroupType;

  factory ChatGroup.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ChatGroupToJson(this);
}
