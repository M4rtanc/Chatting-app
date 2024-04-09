import 'package:chat_app/models/chat_group.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

@JsonSerializable()
class Attachment {
  const Attachment({
    required this.id,
    required this.url,
    required this.type,
  });

  final String id;
  final String url;
  final String type;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
