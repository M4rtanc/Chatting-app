import 'dart:async';
import 'dart:collection';

import 'package:chat_app/services/chat_group_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_group_with_users.dart';
import '../shared/enums/chat_group_filter_type.dart';
import '../shared/ioc_container.dart';

class ChatGroupsNotifier extends ChangeNotifier {

  final _chatGroupService = get<ChatGroupService>();
  ChatGroupFilterType _type = ChatGroupFilterType.none;
  String _searchText = "";
  bool _isInit = false;

  String get searchText => _searchText;
  ChatGroupFilterType get type => _type;
  List<ChatGroupWithUsers> _chatGroups = [];
  StreamSubscription<List<ChatGroupWithUsers>>? _chatGroupSubscription;

  void initChatGroups(List<ChatGroupWithUsers> chatGroups, String userId) {
    _isInit = true;
    _chatGroups = chatGroups;

    _chatGroupSubscription?.cancel();

    _chatGroupSubscription = _chatGroupService.getChatGroupsByUserId(userId).listen((groups) {
      _chatGroups = groups;
      notifyListeners();
    });
  }

  List<ChatGroupWithUsers> get chatGroups => _filter(_chatGroups);
  bool get isInit => _isInit;

  void updateType(ChatGroupFilterType type) {
    if (_type == type) {
      _type = ChatGroupFilterType.none;
    } else {
      _type = type;
    }

    notifyListeners();
  }

  void changeSearchText(String newSearchText) {
    _searchText = newSearchText;
    notifyListeners();
  }

  List<ChatGroupWithUsers> _filter(List<ChatGroupWithUsers> chatGroups) {
    return UnmodifiableListView(
      chatGroups.where((element) {
        final nameMatches = element.name.toLowerCase().contains(_searchText.toLowerCase());

        if (_type == ChatGroupFilterType.none) {
          return nameMatches;
        } else {
          return element.type == _type && nameMatches;
        }
      }),
    );
  }

}