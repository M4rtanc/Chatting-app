// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppMessage _$AppMessageFromJson(Map<String, dynamic> json) => AppMessage(
      id: json['id'] as String? ?? "",
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      chatGroupId: json['chatGroupId'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$AppMessageToJson(AppMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'chatGroupId': instance.chatGroupId,
      'type': _$MessageTypeEnumMap[instance.type]!,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.file: 'file',
  MessageType.image: 'image',
};
