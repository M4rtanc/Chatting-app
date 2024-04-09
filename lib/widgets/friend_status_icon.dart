import 'package:chat_app/services/friends_service.dart';
import 'package:chat_app/shared/enums/friend_state.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:flutter/material.dart';

class FriendStatusIcon extends StatefulWidget {
  final String userEmail;
  const FriendStatusIcon({
    super.key,
    required this.userEmail,
  });

  @override
  State<FriendStatusIcon> createState() => _FriendStateIconState();
}

class _FriendStateIconState extends State<FriendStatusIcon> {
  final _friendService = get<FriendsService>();
  late Future<FriendState> _friendState;

  @override
  initState() {
    super.initState();
    _friendState = _friendService.getFriendState(widget.userEmail);
    print("initState Called");
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _friendState,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error!}');
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        switch(snapshot.data!) {
          case FriendState.friend:
            print("FriendState.friend");
            return IconButton(
              icon: const Icon(Icons.check_circle),
              color: Colors.green,
              tooltip: "Friends",
              onPressed: () {},
            );
          case FriendState.reqSent:
            print("FriendState.reqSent");
            return IconButton(
              icon: const Icon(Icons.watch_later_outlined),
              color: Colors.blue,
              tooltip: "Waiting for response",
              onPressed: () {},
            );
          case FriendState.reqReceived:
            print("Add friend");
            return IconButton(
              icon: const Icon(Icons.check_circle_outline),
              color: Colors.orange,
              tooltip: "Accept friend request",
              onPressed: () {
                _friendService.addFriend(widget.userEmail);
                setState(() {_friendState = _friendService.getFriendState(widget.userEmail);});
              },
            );
          case FriendState.notFriend:
            print("FriendState.notFriend");
            return IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: Colors.blue,
              tooltip: "Send friend request",
              onPressed: () {
                _friendService.sendFriendRequest(widget.userEmail);
                setState(() {_friendState = _friendService.getFriendState(widget.userEmail);});
              },
            );
        }
      }
    );
  }
}
