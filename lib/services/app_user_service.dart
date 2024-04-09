import 'dart:async';

import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/models/friends_model.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/profile_image_service.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:chat_app/shared/util/firebase_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';

class AppUserService extends FirebaseService<AppUser> {
  final _authService = get<AuthenticationService>();

  final _friendsCollection =
  FirebaseFirestore.instance.collection('friends').withConverter(
    fromFirestore: (snapshot, _) =>
        Friends.fromJson(withId(snapshot.data()!, snapshot.id)),
    toFirestore: (value, _) => withoutId(value.toJson()),
  );
  final _usersCollection =
  FirebaseFirestore.instance.collection('users').withConverter(
    fromFirestore: (snapshot, _) =>
        AppUser.fromJson(withId(snapshot.data()!, snapshot.id)),
    toFirestore: (value, _) => withoutId(value.toJson()),
  );


  AppUserService()
      : super(FirebaseFirestore.instance.collection('users').withConverter(
      fromFirestore: (snapshot, _) =>
          AppUser.fromJson(withId(snapshot.data()!, snapshot.id)),
      toFirestore: (value, _) => withoutId(value.toJson()))
  );

  Future<AppUser> getCurrentUser() async {
    final firebaseUser = _authService.getCurrentUser();
    final user = await getFirstOrNullByEmail(firebaseUser?.email ?? "");

    if (user == null) {
      throw Exception("User is not logged!");
    }

    return user;
  }

  Stream<List<AppUser>> get usersWithoutMeStream {
    final authService = get<AuthenticationService>();

    return stream.map((users) =>
        users.where((user) =>
        user.email != authService
            .getCurrentUser()
            ?.email).toList());
  }

  Future<DocumentSnapshot<AppUser>> createAppUser(AppUser appUser) async {
    final newUser = await create(appUser);
    await _friendsCollection.add(Friends(
      userEmail: appUser.email,
      friends: [],
      inFriendRequests: [],
      outFriendRequests: [],
    ));
    return newUser;
  }

  Future<void> editeUserProfile(String? newUrl, String newUserName,
      String newPassword) async {
    print("newUrl: $newUrl");
    var currentEmail = _authService.getCurrentUser()?.email;

    var userRef = (await _usersCollection
        .where("email", isEqualTo: currentEmail)
        .get()).docs.first.reference;


    userRef.update({
      "username": newUserName,
    });
    if (newUrl != "") {
      userRef.update({
        "imageUrl": newUrl,
      });
    }
    if (newPassword != "") {
      _authService.changePassword(newPassword);
    }

    return;
  }
}
