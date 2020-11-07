import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<User> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  User getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  bool isEmailVerified();

  bool isLoggedIn();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password,);

    return result.user;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password,);
    User user = result.user;
    return user.uid ?? "";
  }

  User getCurrentUser(){
    User user =  _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser;
    return user.sendEmailVerification();
  }

  bool isEmailVerified(){
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  bool isLoggedIn(){
    return _firebaseAuth.currentUser != null;
  }
}