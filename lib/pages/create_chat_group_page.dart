import 'package:chat_app/models/chat_group.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/chat_group_service.dart';
import 'package:chat_app/services/friends_service.dart';
import 'package:chat_app/widgets/search_field.dart';
import 'package:chat_app/widgets/user_mark.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../shared/const.dart';
import '../shared/enums/chat_group_type.dart';
import '../shared/ioc_container.dart';
import '../widgets/user_list_tile.dart';

class CreateChatGroupPage extends StatefulWidget {


  const CreateChatGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateChatGroupPage> createState() => _CreateChatGroupPageState();
}

class _CreateChatGroupPageState extends State<CreateChatGroupPage> {

  final _nameController = TextEditingController();
  String _searchText = "";
  final _userService = get<AppUserService>();
  final _friendsService = get<FriendsService>();
  final _chatGroupService = get<ChatGroupService>();
  final Map<String, bool> _markedUsers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Chat Group"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.check, size: 30.0),
              onPressed: () async {
                final currentUser = await _userService.getCurrentUser();
                List<String> userIds = _markedUsers.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();

                _chatGroupService.createChatGroupWithUsers(ChatGroup(
                    name: _nameController.value.text,
                    description: "chat-group",
                    createdAt: DateTime.now(),
                    chatGroupType: ChatGroupType.group
                ), currentUser.id, userIds);

                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(BIG_PADDING),
            child: Column(
              children: [
                _buildNameField(),

                const Divider(),
                Text("Friends",
                    style: TextStyle(color: Colors.black.withOpacity(OPACITY))),
                SearchField(onChanged: (query) {
                  setState(() {
                    _searchText = query;
                  });
                }, hintText: "Search friend",),
                const SizedBox(height: BIG_PADDING),
                _buildUsers(),
              ],
            )
        )
    );
  }

  Widget _buildNameField() {
    return TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(OPACITY),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            labelText: "Name"
        ),
        controller: _nameController
    );
  }

  Widget _buildUsers() {
    return FutureBuilder(
      future: _friendsService.getCurrentUserFriends(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        final users = snapshot.data ?? [];
        final filteredUsers = users
            .where((user) =>
            user.username.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();

        return Expanded(
          child: ListView.separated(
            itemCount: filteredUsers.length,
            itemBuilder: (_, index) {
              final user = filteredUsers[index];

              return ListTile(
                title: UserMark(
                  isMarked: _markedUsers[user.id] ?? false,
                  appUser: user,
                ),
                onTap: () async {
                  setState(() {
                    final mark = _markedUsers[user.id];

                    if (mark == null) {
                      _markedUsers[user.id] = true;
                    } else {
                      _markedUsers[user.id] = !mark;
                    }
                  });
                },
              );
            },
            separatorBuilder: (_, __) =>
            const Divider(height: 2.0, thickness: 2),
          ),
        );
      },
    );
  }
}
