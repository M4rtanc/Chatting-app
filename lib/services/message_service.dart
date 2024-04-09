import 'package:chat_app/mappers/message_mapper.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../mappers/user_mapper.dart';
import '../models/app_message.dart';
import '../shared/enums/message_type.dart';
import '../shared/ioc_container.dart';
import '../shared/util/firebase_id.dart';
import 'firebase_service.dart';

class MessageService extends FirebaseService<AppMessage> {

  final _userService = get<AppUserService>();
  final _messageMapper = MessageMapper();
  final _storageService = get<StorageService>();

  MessageService() : super(FirebaseFirestore.instance.collection('messages').withConverter(
    fromFirestore: (snapshot, _) =>
        AppMessage.fromJson(withId(snapshot.data()!, snapshot.id)),
    toFirestore: (value, _) => withoutId(value.toJson()))
  );

  Stream<List<AppMessage>> messagesByGroupIdStream(String groupId) {
    return collection
        .where('chatGroupId', isEqualTo: groupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((it) => it.data()).toList());
  }

  Stream<List<types.Message>> getFlutterMessagesByGroupId(String groupId) {
    final stream = messagesByGroupIdStream(groupId);

    return stream.asyncMap((list) async {
      final messages = <types.Message>[];

      for (final msg in list) {
        final appUser = _userService.getById(msg.userId);
        
        if (msg.type == MessageType.image) {
          final reference = _storageService.getRef(msg.content);

          messages.add(_messageMapper.toFlutterImageMessage(
              msg,
              await reference.getDownloadURL(),
              (await reference.getMetadata()).size ?? 0,
              (await appUser).data() ?? AppUser(id: msg.userId, username: "", email: "")
          ));
        } else {
          messages.add(_messageMapper.toFlutterTextMessage(msg, (await appUser).data() ?? AppUser(id: msg.userId, username: "", email: "")));
        }
      }

      return messages;
    });
  }
}
