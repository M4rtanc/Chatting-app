import 'package:chat_app/models/chat_group.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/shared/enums/user_chat_group_role.dart';
import 'package:json_annotation/json_annotation.dart';

import '../shared/enums/chat_group_type.dart';
import 'app_message.dart';

part 'user_chat_group.g.dart';

@JsonSerializable()
class UserChatGroup {
  const UserChatGroup(
      {required this.createdAt,
      required this.userId,
      required this.chatGroupId,
      required this.userChatGroupRole});

  final DateTime createdAt;
  final String userId;
  final String chatGroupId;
  final UserChatGroupRole userChatGroupRole;

  factory UserChatGroup.fromJson(Map<String, dynamic> json) =>
      _$UserChatGroupFromJson(json);

  Map<String, dynamic> toJson() => _$UserChatGroupToJson(this);
}
