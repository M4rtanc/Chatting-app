import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../models/chat_group_with_users.dart';
import '../notifiers/chat_groups.dart';
import '../pages/chat_page.dart';
import '../services/chat_group_service.dart';
import '../shared/const.dart';
import '../shared/enums/chat_group_filter_type.dart';
import '../shared/ioc_container.dart';
import 'chat_group_filter.dart';

class ChatGroupList extends StatefulWidget {

  final AppUser currentUser;

  const ChatGroupList({super.key, required this.currentUser});

  @override
  _ChatGroupListState createState() => _ChatGroupListState();
}

class _ChatGroupListState extends State<ChatGroupList> {

  final _chatGroupService = get<ChatGroupService>();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ChatGroupsNotifier>();

    return Column(
      children: [
        const ChatGroupFilter(),
        const SizedBox(height: BIG_PADDING),
        _buildChatGroups(widget.currentUser, notifier),
      ],

    );
  }

  Widget _buildChatGroups(AppUser currentUser, ChatGroupsNotifier notifier) {
    if (notifier.isInit) {
      return _buildChatGroupList(notifier.chatGroups);
    } else {
      return StreamBuilder(
        stream: _chatGroupService.getChatGroupsByUserId(currentUser.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<ChatGroupWithUsers> chatGroupsWithUsers = snapshot.data ?? [];
          notifier.initChatGroups(chatGroupsWithUsers, currentUser.id);

          return _buildChatGroupList(notifier.chatGroups);
        },
      );
    }
  }

  Widget _buildChatGroupList(List<ChatGroupWithUsers> list) {
    return Expanded(
      child: ListView.separated(
        itemCount: list.length,
        itemBuilder: (_, index) {
          return _buildChatGroupItem(list[index]);
        },
        separatorBuilder: (_, __) =>
        const Divider(height: 2.0, thickness: 2),
      ),
    );
  }

  Widget _buildChatGroupItem(ChatGroupWithUsers chatGroupWithUsers) {
    final icon = chatGroupWithUsers.type == ChatGroupFilterType.my ? myIcon
        : chatGroupWithUsers.type == ChatGroupFilterType.chats ? chatsIcon : chatGroupsIcon;

    return ListTile(
      title: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(chatGroupWithUsers.name)
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatPage(chatGroupWithUsers: chatGroupWithUsers)));
      },
    );
  }
}
