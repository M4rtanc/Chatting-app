// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserChatGroup _$UserChatGroupFromJson(Map<String, dynamic> json) =>
    UserChatGroup(
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      chatGroupId: json['chatGroupId'] as String,
      userChatGroupRole:
          $enumDecode(_$UserChatGroupRoleEnumMap, json['userChatGroupRole']),
    );

Map<String, dynamic> _$UserChatGroupToJson(UserChatGroup instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'chatGroupId': instance.chatGroupId,
      'userChatGroupRole':
          _$UserChatGroupRoleEnumMap[instance.userChatGroupRole]!,
    };

const _$UserChatGroupRoleEnumMap = {
  UserChatGroupRole.creator: 'creator',
  UserChatGroupRole.user: 'user',
  UserChatGroupRole.manager: 'manager',
  UserChatGroupRole.none: 'none',
};
