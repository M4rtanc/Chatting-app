import 'package:chat_app/mappers/user_mapper.dart';
import 'package:chat_app/models/app_message.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/shared/enums/message_type.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../shared/ioc_container.dart';

class MessageMapper {

  final UserMapper _userMapper = UserMapper();

  types.Message toFlutterTextMessage(AppMessage message, AppUser appUser) {
    return types.TextMessage(
        id: message.id,
        author: _userMapper.toFlutterUser(appUser),
        createdAt: message.createdAt.millisecondsSinceEpoch,
        text: message.content
    );
  }

  types.ImageMessage toFlutterImageMessage(
      AppMessage message,
      String uri,
      int size,
      AppUser appUser
      ) {
    return types
        .ImageMessage(
        author: _userMapper.toFlutterUser(appUser),
        createdAt: message.createdAt.millisecondsSinceEpoch,
        id: message.id,
        name: message.content,
        size: size,
        uri: uri,
    );
  }
}
