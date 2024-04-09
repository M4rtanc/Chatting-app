import 'package:chat_app/notifiers/chat_groups.dart';
import 'package:chat_app/shared/enums/chat_group_filter_type.dart';
import 'package:chat_app/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const myIcon = Icons.person;
const chatsIcon = Icons.chat_rounded;
const chatGroupsIcon = Icons.wechat;

class ChatGroupFilter extends StatelessWidget {

  const ChatGroupFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ChatGroupsNotifier>();

    return _buildTags(notifier);
  }

  Widget _buildTags(ChatGroupsNotifier notifier) {
    return Row(
      children: [
        Expanded(child: Container()),
        IconButton(
          icon: const Icon(myIcon),
          color: notifier.type == ChatGroupFilterType.my ? Colors.black87 : Colors.black38,
          tooltip: 'Your chat groups',
          onPressed: () {
            notifier.updateType(ChatGroupFilterType.my);
          },
        ),
        Expanded(child: Container()),
        IconButton(
          icon: const Icon(chatsIcon),
          color: notifier.type == ChatGroupFilterType.chats ? Colors.black87 : Colors.black38,
          tooltip: 'Chats',
          onPressed: () {
            notifier.updateType(ChatGroupFilterType.chats);
          },
        ),
        Expanded(child: Container()),
        IconButton(
          icon: const Icon(chatGroupsIcon),
          color: notifier.type == ChatGroupFilterType.chatGroups ? Colors.black87 : Colors.black38,
          tooltip: 'Chat groups',
          onPressed: () {
            notifier.updateType(ChatGroupFilterType.chatGroups);
          },
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
