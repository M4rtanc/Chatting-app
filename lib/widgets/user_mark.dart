import 'package:chat_app/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';

class UserMark extends StatelessWidget {
  final AppUser appUser;
  final bool isMarked;

  const UserMark({Key? key, required this.appUser, required this.isMarked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: UserListTile(user: appUser)
        ),
        Icon(isMarked ? Icons.check : Icons.circle),
      ],
    );
  }
}
