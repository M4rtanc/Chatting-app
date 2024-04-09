import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/chat_group_service.dart';
import 'package:chat_app/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';

import '../shared/const.dart';
import '../shared/ioc_container.dart';
import '../widgets/app_drawer.dart';
import '../widgets/search_field.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _userService = get<AppUserService>();
  final _chatGroupService = get<ChatGroupService>();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(BIG_PADDING),
        child: Column(
          children: [
            SearchField(onChanged: (query) {
              setState(() {
                _searchText = query;
              });
            }),
            SizedBox(height: BIG_PADDING),
            StreamBuilder(
                stream: _userService.usersWithoutMeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }

                  final users = snapshot.data;

                  if (users == null) {
                    return const Text("No data");
                  } else {
                    final filteredUsers = users
                        .where((user) =>
                        user.username.toLowerCase().contains(_searchText.toLowerCase()))
                        .toList();

                    return Expanded(
                        child: ListView.separated(
                      itemCount: filteredUsers.length,
                      itemBuilder: (_, index) {
                        final user = filteredUsers[index];

                        return UserListTile(user: user);
                      },
                      separatorBuilder: (_, __) =>
                          const Divider(height: 2.0, thickness: 2),
                    ));
                  }
                })
          ],
        ),
      ),
    );
  }
}
