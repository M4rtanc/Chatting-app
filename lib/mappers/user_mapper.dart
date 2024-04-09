import 'package:chat_app/models/app_user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserMapper {
  types.User toFlutterUser(AppUser appUser) {
    return types.User(
        id: appUser.id,
        firstName: appUser.username,
        lastName: "",
        imageUrl: appUser.imageUrl);
  }

  AppUser toAppUser(types.User user) {
    return AppUser(
        id: user.id,
        username: user.firstName ?? "Default firstName",
        email: user.lastName ?? "Default lastName",
        imageUrl: user.imageUrl ?? "Default imageUrl"
    );
  }

  AppUser toAppUserFromFirebase(firebase.User user) {
    return AppUser(
        username: user.displayName ?? "defaultUserName",
        email: user.email ?? "defaultEmail",
    );
  }
}
