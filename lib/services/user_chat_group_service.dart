import 'package:chat_app/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_chat_group.dart';
import '../shared/util/firebase_id.dart';

class UserChatGroupService extends FirebaseService<UserChatGroup> {

  UserChatGroupService() : super(FirebaseFirestore.instance.collection('users__chat_groups').withConverter(
    fromFirestore: (snapshot, _) =>
        UserChatGroup.fromJson(withId(snapshot.data()!, snapshot.id)),
    toFirestore: (value, _) => withoutId(value.toJson()))
  );
}
