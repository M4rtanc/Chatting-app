// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      id: json['id'] as String? ?? "",
      username: json['username'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl'] as String? ?? "defaultImageUrl",
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
    };
