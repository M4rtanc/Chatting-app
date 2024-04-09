import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signOutCurrentUser() async {
    _auth.signOut();
  }

  bool changePassword(String newPassword) {
    var currentUser = getCurrentUser();
    if (currentUser == null) {
      print("updatePassword: currentUser == null");
      return false;
    }

    currentUser.updatePassword(newPassword).catchError((error) {
      print("changePassword: $error");
    });
    return true;
  }
}
