import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/chat_group.dart';
import 'package:chat_app/models/user_chat_group.dart';
import 'package:chat_app/shared/enums/chat_group_filter_type.dart';
import 'package:json_annotation/json_annotation.dart';

import '../shared/enums/chat_group_type.dart';
import 'app_message.dart';

class ChatGroupWithUsers {
  const ChatGroupWithUsers({
    required this.chatGroup,
    required this.userRelations,
    required this.name,
    required this.type
  });

  final ChatGroup chatGroup;
  final List<UserChatGroup> userRelations;
  final String name;
  final ChatGroupFilterType type;
}
