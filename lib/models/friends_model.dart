import 'package:json_annotation/json_annotation.dart';

part 'friends_model.g.dart';

@JsonSerializable()
class Friends {
  const Friends({
    this.id,
    required this.userEmail,
    required this.friends,
    required this.outFriendRequests,
    required this.inFriendRequests,
    this.imageUrl = "defaultImageUrl",
  });

  final String? id;
  final String userEmail;
  final List<String> friends;
  final List<String> outFriendRequests;
  final List<String> inFriendRequests;
  final String imageUrl;

  factory Friends.fromJson(Map<String, dynamic> json) => _$FriendsFromJson(json);

  Map<String, dynamic> toJson() => _$FriendsToJson(this);
}
