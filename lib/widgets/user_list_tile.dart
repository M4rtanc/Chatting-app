import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/chat_group_service.dart';
import 'package:chat_app/services/friends_service.dart';
import 'package:chat_app/services/profile_image_service.dart';
import 'package:chat_app/shared/enums/friend_state.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:chat_app/widgets/friend_status_icon.dart';
import 'package:chat_app/widgets/profile_image.dart';
import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  UserListTile({
    super.key,
    required this.user
  });

  final AppUser user;

  final _userService = get<AppUserService>();

  final _friendService = get<FriendsService>();

  final _chatGroupService = get<ChatGroupService>();

  final _profileImageService = get<ProfileImageService>();

  @override
  ListTile build(BuildContext context) {
    return ListTile(
      title: Text(user.username),
      subtitle: Text(user.email),
      leading: ProfileImage(imageUrl: user.imageUrl),
      trailing: FriendStatusIcon(userEmail: user.email),
      onTap: () async {
        if ((await _friendService.getFriendState(user.email)) != FriendState.friend) {
          final failureSnackBar = SnackBar(
            content: Text("User ${user.username} is not your friend"),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(failureSnackBar);
          return;
        }

        final currentUser = await _userService.getCurrentUser();

        final chatGroupWithUsers = await _chatGroupService
              .getSingle(currentUser, user);

        Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChatPage(
                      chatGroupWithUsers:
                      chatGroupWithUsers)));
      },
    );
  }
}
