import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _appUserService = get<AppUserService>();

  Future<bool> updateUserName(String newUserName) async {
    var currentUser = await _appUserService.getCurrentUser();
    if (currentUser == null) {
      print("updateUserName: current user not found");
      return false;
    }

    _db.collection("users")
        .where("email", isEqualTo: currentUser.email)
        .get()
        .then((snapshot) {
          snapshot.docs.first.reference.update({"username": newUserName});
        }).catchError((error) {
          throw error;
        });

    return true;
  }

  bool updatePassword(String newPassword) {
    var currentUser = _auth.currentUser;
    if (currentUser == null) {
      print("updatePassword: current user not found");
      return false;
    }

    currentUser.updatePassword(newPassword).catchError((error) {
      throw error;
    });

    return true;
  }

  bool deleteAccount() {


    return true;
  }
}
