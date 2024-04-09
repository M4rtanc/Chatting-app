import 'package:chat_app/mappers/message_mapper.dart';
import 'package:chat_app/mappers/user_mapper.dart';
import 'package:chat_app/models/app_message.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/chat_group.dart';
import 'package:chat_app/models/chat_group_with_users.dart';
import 'package:chat_app/services/chat_group_service.dart';
import 'package:chat_app/services/message_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/shared/enums/chat_group_filter_type.dart';
import 'package:chat_app/shared/enums/chat_group_type.dart';
import 'package:chat_app/shared/enums/message_type.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../services/app_user_service.dart';
import '../shared/const.dart';
import '../shared/ioc_container.dart';

class ChatPage extends StatefulWidget {
  final ChatGroupWithUsers chatGroupWithUsers;

  const ChatPage({Key? key, required this.chatGroupWithUsers})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _userService = get<AppUserService>();
  final _storageService = get<StorageService>();
  final _userMapper = UserMapper();
  final _messageService = get<MessageService>();
  final _chatGroupService = get<ChatGroupService>();
  late AppUser _currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: _userService.getCurrentUser(),
      builder: _buildApp,
    );
  }

  Scaffold _buildApp(BuildContext context, AsyncSnapshot<AppUser> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (snapshot.hasError) {
      return const Scaffold(body: Center(child: Text('Error')));
    }

    final chatGroupWithUsers = widget.chatGroupWithUsers;
    _currentUser = snapshot.data!;

    return Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
          centerTitle: true,
          actions: chatGroupWithUsers.type == ChatGroupFilterType.my ? [
            IconButton(
              icon: const Icon(Icons.delete, size: 30.0),
              onPressed: () async {
                await _chatGroupService.deleteById(chatGroupWithUsers.chatGroup.id);

                Navigator.pop(context);
              },
            ),
          ] : [],
        ),
        body: StreamBuilder(
            stream: _messageService.getFlutterMessagesByGroupId(
                chatGroupWithUsers.chatGroup.id
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final messages = snapshot.data ?? [];

              return Chat(
                messages: messages,
                onAttachmentPressed: _handleAttachmentPressed,
                onSendPressed: _handleSendPressed,
                user: _userMapper.toFlutterUser(_currentUser),
                showUserAvatars: true,
                showUserNames: true,
              );
            })
    );
  }

  _handleSendPressed(types.PartialText msg) {
    final chatGroupWithUsers = widget.chatGroupWithUsers;

    _messageService.create(AppMessage(
        content: msg.text,
        createdAt: DateTime.now(),
        userId: _currentUser.id,
        chatGroupId: chatGroupWithUsers.chatGroup.id,
        type: MessageType.text
    ));
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BIG_PADDING),
          child: IconButton(
            icon: const Icon(Icons.image_outlined),
            tooltip: 'Upload image',
            onPressed: () {
              Navigator.pop(context);
              _handleImageSelection();
            },
          ),
        )
      ),
    );
  }

  void _handleImageSelection() async {
    final file = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (file != null) {
      final chatGroupWithUsers = widget.chatGroupWithUsers;
      final uploadTask = await _storageService.uploadImage(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            break;
          case TaskState.success:
            _messageService.create(AppMessage(
                content: uploadTask.snapshot.ref.fullPath,
                createdAt: DateTime.now(),
                userId: _currentUser.id,
                chatGroupId: chatGroupWithUsers.chatGroup.id,
                type: MessageType.image
            ));
            break;
          case TaskState.error:
            break;
          case TaskState.paused:
          case TaskState.canceled:
        }
      });
    }
  }

  FutureBuilder<String> _buildTitle() {
    return FutureBuilder<String>(
      future: _getChatGroupName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          return Text(snapshot.data ?? 'Chat');
        }
      },
    );
  }

  Future<String> _getChatGroupName() async {
    final chatGroupWithUsers = widget.chatGroupWithUsers;

    if (chatGroupWithUsers.chatGroup.chatGroupType == ChatGroupType.single) {
      final userId = chatGroupWithUsers.userRelations
          .where((element) => element.userId != _currentUser.id)
          .first
          .userId;
      final user = await _userService.getById(userId);
      return user.data()?.username ?? "Error chat name";
    }

    return chatGroupWithUsers.chatGroup.name;
  }
}
