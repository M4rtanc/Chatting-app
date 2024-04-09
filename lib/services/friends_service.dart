import 'dart:async';

import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/shared/enums/friend_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../mappers/user_mapper.dart';
import '../models/friends_model.dart';
import '../shared/ioc_container.dart';
import '../shared/util/firebase_id.dart';
import 'app_user_service.dart';

class FriendsService {
  final _authService = get<AuthenticationService>();
  final _appUserService = get<AppUserService>();
  final _userCollection =
  FirebaseFirestore.instance.collection('users').withConverter(
    fromFirestore: (snapshot, _) =>
        AppUser.fromJson(withId(snapshot.data()!, snapshot.id)),
    toFirestore: (value, _) => withoutId(value.toJson()),
  );
  final _friendsCollection =
  FirebaseFirestore.instance.collection('friends').withConverter(
    fromFirestore: (snapshot, _) =>
        Friends.fromJson(withId(snapshot.data()!, snapshot.id)),
    toFirestore: (value, _) => withoutId(value.toJson()),
  );

  Future<List<String>> _getCurrentFriendEmails() async {
    var currentEmail = _authService.getCurrentUser()?.email;
    if (currentEmail == null) {
      print("1");
      return [];
    }

    String docId = await _friendsCollection
        .where('userEmail', isEqualTo: currentEmail)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        print("2");
        return "";
      }
      return snapshot.docs.first.id;
    }).catchError((error) {
      print("getCurrentFriendEmails: $error");
      throw error;
    });
    print("3");
    var snapshot = await _friendsCollection.doc(docId).get();
    print("4");
    var result = snapshot.data()?.friends ?? [];
    print("5, len: ${result.length}");
    return result;
  }

  Future<List<String>> _getUserFriendEmails(String userEmail) async {
    String docId = await _friendsCollection
        .where('userEmail', isEqualTo: userEmail)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        print("2");
        return "";
      }
      return snapshot.docs.first.id;
    }).catchError((error) {
      print("getCurrentFriendEmails: $error");
      throw error;
    });
    print("3");
    var snapshot = await _friendsCollection.doc(docId).get();
    print("4");
    var result = snapshot.data()?.friends ?? [];
    print("5, len: ${result.length}");
    return result;
  }

  Future<List<AppUser>> getCurrentUserFriends() async {
    final emails = await _getCurrentFriendEmails();

    final friends = await _userCollection
        .where('email', whereIn: emails.isEmpty ? [""] : emails)
        .get();

    return friends.docs.map((doc) => doc.data()).toList();
  }


  Future<bool> addFriend(String friendEmail) async {
    var currentEmail = _authService.getCurrentUser()?.email;
    if (currentEmail == null) {
      return false;
    }

    var currentUserFriendList = await _getCurrentFriendEmails();
    var currentUserInReqList = await _getInFriendRequests(currentEmail);
    var currentUserOutReqList = await _getOutFriendRequests(currentEmail);
    if (!currentUserFriendList.contains(friendEmail)) {
      currentUserFriendList.add(friendEmail);
      currentUserInReqList.remove(friendEmail);
      currentUserOutReqList.remove(friendEmail);
    } else {
      print("addFriend: friend $friendEmail already in list");
      return false;
    }
    var result1 = FirebaseFirestore.instance.collection("friends")
        .where("userEmail", isEqualTo: currentEmail)
        .get()
        .then((snapshot) {
      snapshot.docs.first.reference.update({
        "friends": currentUserFriendList,
        "inFriendRequests": currentUserInReqList,
        "outFriendRequests": currentUserOutReqList,
      });
      return true;
    }).catchError((error) {
      print("addFriend: $error");
      return false;
    });

    var otherUserFriendList = await _getUserFriendEmails(friendEmail);
    var otherUserInReqList = await _getInFriendRequests(friendEmail);
    var otherUserOutReqList = await _getOutFriendRequests(friendEmail);
    if (!otherUserFriendList.contains(currentEmail)) {
      otherUserFriendList.add(currentEmail);
      otherUserInReqList.remove(currentEmail);
      otherUserOutReqList.remove(currentEmail);
    } else {
      print("addFriend: friend $currentEmail already in list");
      return false;
    }
    var result2 = FirebaseFirestore.instance.collection("friends")
        .where("userEmail", isEqualTo: friendEmail)
        .get()
        .then((snapshot) {
      snapshot.docs.first.reference.update({
        "friends": otherUserFriendList,
        "inFriendRequests": otherUserInReqList,
        "outFriendRequests": otherUserOutReqList,
      });
      return true;
    }).catchError((error) {
      print("addFriend: $error");
      return false;
    });

    return (await result1) & (await result2);
  }

  Future<bool> removeFriend(String friendEmail) async {
    var currentEmail = _authService.getCurrentUser()?.email;
    if (currentEmail == null) {
      return false;
    }
    var friendList = await _getCurrentFriendEmails();
    if (friendList.contains(friendEmail)) {
      friendList.remove(friendEmail);
    } else {
      print("removeFriend: friend $friendEmail not in list");
      return false;
    }

    var result = FirebaseFirestore.instance.collection("friends")
        .where("userEmail", isEqualTo: currentEmail)
        .get()
        .then((snapshot) {
      snapshot.docs.first.reference.update({"friends": friendList});
      return true;
    }).catchError((error) {
      print("addFriend: $error");
      return false;
    });

    return result;
  }

  Future<List<String>> _getOutFriendRequests(String userEmail) async {
    String docId = await _friendsCollection
        .where('userEmail', isEqualTo: userEmail)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        print("_getOutFriendRequests: email $userEmail not found");
        return "";
      }
      return snapshot.docs.first.id;
    }).catchError((error) {
      print("_getOutFriendRequests: $error");
      throw error;
    });

    var snapshot = await _friendsCollection.doc(docId).get();
    return snapshot.data()?.outFriendRequests ?? [];
  }

  Future<List<String>> _getInFriendRequests(String userEmail) async {
    String docId = await _friendsCollection
        .where('userEmail', isEqualTo: userEmail)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        print("_getInFriendRequests: email $userEmail not found");
        return "";
      }
      return snapshot.docs.first.id;
    }).catchError((error) {
      print("_getInFriendRequests: $error");
      throw error;
    });

    var snapshot = await _friendsCollection.doc(docId).get();
    return snapshot.data()?.inFriendRequests ?? [];
  }

  Future<bool> sendFriendRequest(String toUserEmail) async {
    print("sendFriendRequest running");
    var currentEmail = _authService.getCurrentUser()?.email;
    if (currentEmail == null) {
      return false;
    }

    var outFriendReqList = await _getOutFriendRequests(currentEmail);
    if (!outFriendReqList.contains(toUserEmail)) {
      outFriendReqList.add(toUserEmail);
    } else {
      print("sendFriendRequest: $toUserEmail already in outFriendReqList");
      return false;
    }
    var outResult = await FirebaseFirestore.instance.collection("friends")
        .where("userEmail", isEqualTo: currentEmail)
        .get()
        .then((snapshot) {
      snapshot.docs.first.reference.update({"outFriendRequests": outFriendReqList});
      return true;
    }).catchError((error) {
      print("sendFriendRequest: $error");
      return false;
    });

    var inFriendReqList = await _getInFriendRequests(currentEmail);
    if (!inFriendReqList.contains(currentEmail)) {
      inFriendReqList.add(currentEmail);
    } else {
      print("sendFriendRequest: $currentEmail already in inFriendReqList");
      return false;
    }
    var inResult = await FirebaseFirestore.instance.collection("friends")
        .where("userEmail", isEqualTo: toUserEmail)
        .get()
        .then((snapshot) {
      snapshot.docs.first.reference.update({"inFriendRequests": inFriendReqList});
      return true;
    }).catchError((error) {
      print("sendFriendRequest: $error");
      return false;
    });

    return outResult & inResult;
  }

  Future<FriendState> getFriendState(String userEmail) async {
    AppUser currentUser = await _appUserService.getCurrentUser();

    if ((await _getCurrentFriendEmails()).contains(userEmail)) {
      print("1");
      return FriendState.friend;
    }

    if ((await _getInFriendRequests(currentUser.email)).contains(userEmail)) {
      return FriendState.reqReceived;
    }

    if ((await _getOutFriendRequests(currentUser.email)).contains(userEmail)) {
      print("3");
      return FriendState.reqSent;
    }

    return FriendState.notFriend;
  }
}
