// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGroup _$ChatGroupFromJson(Map<String, dynamic> json) => ChatGroup(
      id: json['id'] as String? ?? "",
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String? ?? "defaultImageUrl",
      createdAt: DateTime.parse(json['createdAt'] as String),
      chatGroupType: $enumDecode(_$ChatGroupTypeEnumMap, json['chatGroupType']),
    );

Map<String, dynamic> _$ChatGroupToJson(ChatGroup instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'chatGroupType': _$ChatGroupTypeEnumMap[instance.chatGroupType]!,
    };

const _$ChatGroupTypeEnumMap = {
  ChatGroupType.single: 'single',
  ChatGroupType.group: 'group',
};
