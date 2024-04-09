import 'package:chat_app/models/chat_group.dart';
import 'package:chat_app/models/chat_group_with_users.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/firebase_service.dart';
import 'package:chat_app/services/message_service.dart';
import 'package:chat_app/services/user_chat_group_service.dart';
import 'package:chat_app/shared/enums/chat_group_filter_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/app_user.dart';
import '../models/user_chat_group.dart';
import '../shared/enums/chat_group_type.dart';
import '../shared/enums/user_chat_group_role.dart';
import '../shared/ioc_container.dart';
import '../shared/util/firebase_id.dart';

class ChatGroupService extends FirebaseService<ChatGroup> {
  final _userChatGroupService = get<UserChatGroupService>();
  final _messageService = get<MessageService>();
  final _userService = get<AppUserService>();

  final _userChatGroupCollection =
  FirebaseFirestore.instance.collection('users__chat_groups').withConverter(
    fromFirestore: (snapshot, _) =>
        UserChatGroup.fromJson(withId(snapshot.data()!, snapshot.id)),
    toFirestore: (value, _) => withoutId(value.toJson()),
  );

  @override
  Future<void> deleteById(String id) async {
    super.deleteById(id);
    _messageService.deleteByChatGroupId(id);
    _userChatGroupService.deleteByChatGroupId(id);
  }

  ChatGroupService() : super(FirebaseFirestore.instance.collection('chat_groups').withConverter(
      fromFirestore: (snapshot, _) =>
          ChatGroup.fromJson(withId(snapshot.data()!, snapshot.id)),
      toFirestore: (value, _) => withoutId(value.toJson()))
  );

  Stream<List<ChatGroupWithUsers>> getChatGroupsByUserId(String currentUserId) {
    return _userChatGroupCollection
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((querySnapshot) async {
      final chatGroupIds = querySnapshot.docs.map((doc) => doc.data().chatGroupId).toList();

      List<ChatGroupWithUsers> chatGroupsWithUsers = [];

      for (String chatGroupId in chatGroupIds) {
        final chatGroupDoc = await getById(chatGroupId);
        final relations = await _userChatGroupService.getByChatGroupId(chatGroupId);

        if (chatGroupDoc.exists) {
          final chatGroup = chatGroupDoc.data();
          if (chatGroup != null) {
            final chatGroupFilterType = chatGroup.chatGroupType == ChatGroupType.single ? ChatGroupFilterType.chats
              : relations
                .where((element) => element.userId == currentUserId)
                .where((element) => element.userChatGroupRole == UserChatGroupRole.creator).isNotEmpty ? ChatGroupFilterType.my : ChatGroupFilterType.chatGroups;

            chatGroupsWithUsers.add(ChatGroupWithUsers(
                chatGroup: chatGroup,
                userRelations: relations,
                name: await getChatGroupName(chatGroup, relations),
                type: chatGroupFilterType
            ));
          }
        }
      }

      return chatGroupsWithUsers;
    });
  }

  Future<String> getChatGroupName(ChatGroup chatGroup, List<UserChatGroup> userRelations) async {
    final currentUser = await _userService.getCurrentUser();

    if (chatGroup.chatGroupType == ChatGroupType.single) {
      final userId = userRelations
          .where((element) => element.userId != currentUser.id)
          .first
          .userId;

      final user = await _userService.getById(userId);
      return user.data()?.username ?? "Error chat name";
    }

    return chatGroup.name;
  }

  Future<DocumentSnapshot<ChatGroup>> createChatGroupWithUsers(ChatGroup chatGroup, String creatorId, List<String> userIds) async {
    final createdChatGroup = await create(chatGroup);
    final chatGroupId = createdChatGroup.data()?.id ?? "";

    _userChatGroupService.create(_getUserRelation(creatorId, chatGroupId, role: UserChatGroupRole.creator));
    for (var userId in userIds) {
      _userChatGroupService.create(_getUserRelation(userId, chatGroupId));
    }

    return createdChatGroup;
  }

  Future<ChatGroupWithUsers> getSingle(AppUser currentUser, AppUser secondUser) async {
    final firstRelations =
        await _userChatGroupService.getByUserId(currentUser.id);
    final secondRelations =
        await _userChatGroupService.getByUserId(secondUser.id);

    final chatGroupIds = firstRelations
        .map((firstRelation) => firstRelation.chatGroupId)
        .toSet()
        .intersection(secondRelations
            .map((secondRelation) => secondRelation.chatGroupId)
            .toSet());

    if (chatGroupIds.isNotEmpty) {
      for (final chatGroupId in chatGroupIds) {
        final chatGroupSnapshot = await getById(chatGroupId);
        final firstUserRelation = firstRelations
            .firstWhere((relation) => relation.chatGroupId == chatGroupId);
        final secondUserRelation = secondRelations
            .firstWhere((relation) => relation.chatGroupId == chatGroupId);

        if (chatGroupSnapshot.exists) {
          final chatGroup = chatGroupSnapshot.data()!;

          if (chatGroup.chatGroupType == ChatGroupType.single) {
            return ChatGroupWithUsers(
              chatGroup: chatGroup,
              userRelations: [firstUserRelation, secondUserRelation],
              name: secondUser.username,
              type: ChatGroupFilterType.chats
            );
          }
        }
      }
    }

    final createdChatGroup = await create(_getEmptySingleChat());
    final chatGroupId = createdChatGroup.data()?.id ?? "";
    final currentRelation = await _userChatGroupService.create(
      _getUserRelation(currentUser.id, chatGroupId),
    );
    final toRelation = await _userChatGroupService.create(
      _getUserRelation(secondUser.id, chatGroupId),
    );

    return ChatGroupWithUsers(
      chatGroup: createdChatGroup.data()!,
      userRelations: [currentRelation.data()!, toRelation.data()!],
      name: secondUser.username,
      type: ChatGroupFilterType.chats
    );
  }

  ChatGroup _getEmptySingleChat() {
    return ChatGroup(
        name: "",
        description: "classic chat one-to-one",
        createdAt: DateTime.now(),
        chatGroupType: ChatGroupType.single);
  }

  UserChatGroup _getUserRelation(String userId, String chatGroupId, {UserChatGroupRole role = UserChatGroupRole.user}) {
    return UserChatGroup(
        createdAt: DateTime.now(),
        userId: userId,
        chatGroupId: chatGroupId,
        userChatGroupRole: role);
  }
}
