import 'package:chat_app/pages/create_chat_group_page.dart';
import 'package:chat_app/widgets/app_drawer.dart';
import 'package:chat_app/widgets/chat_group_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifiers/chat_groups.dart';
import '../services/app_user_service.dart';
import '../shared/const.dart';
import '../shared/ioc_container.dart';
import '../widgets/search_field.dart';

class ChatGroupPage extends StatefulWidget {


  const ChatGroupPage({super.key});

  @override
  State<ChatGroupPage> createState() => _ChatGroupPageState();
}

class _ChatGroupPageState extends State<ChatGroupPage> {
  final _userService = get<AppUserService>();

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<ChatGroupsNotifier>();

    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Chats"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => const CreateChatGroupPage()));
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
            padding: const EdgeInsets.all(BIG_PADDING),
            child: FutureBuilder(
                future: _userService.getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error currentUser!'));
                  } else {
                    final currentUser = snapshot.data!;

                    return Column(
                      children: [
                        SearchField(onChanged: notifier.changeSearchText, text: notifier.searchText, hintText: "Search chat groups",),
                        Expanded(child: ChatGroupList(currentUser: currentUser))
                      ],
                    );
                  }
                }
            )
        )
    );
  }
}
