// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friends _$FriendsFromJson(Map<String, dynamic> json) => Friends(
      id: json['id'] as String?,
      userEmail: json['userEmail'] as String,
      friends:
          (json['friends'] as List<dynamic>).map((e) => e as String).toList(),
      outFriendRequests: (json['outFriendRequests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      inFriendRequests: (json['inFriendRequests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String? ?? "defaultImageUrl",
    );

Map<String, dynamic> _$FriendsToJson(Friends instance) => <String, dynamic>{
      'id': instance.id,
      'userEmail': instance.userEmail,
      'friends': instance.friends,
      'outFriendRequests': instance.outFriendRequests,
      'inFriendRequests': instance.inFriendRequests,
      'imageUrl': instance.imageUrl,
    };
