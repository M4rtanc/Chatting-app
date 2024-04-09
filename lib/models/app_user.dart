import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  const AppUser({
    this.id = "",
    required this.username,
    required this.email,
    this.imageUrl = "https://firebasestorage.googleapis.com/v0/b/pv292-chatting-app-8ed91.appspot.com/o/profile_images%2Fdefault_profile_image.png?alt=media&token=334764b6-6d86-4a27-941c-f3f824296598",
  });

  final String id;
  final String username;
  final String email;
  final String imageUrl;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
