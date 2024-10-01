import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_guard/global/common/toast.dart';
import 'package:fire_guard/models/user_model.dart';
import 'package:fire_guard/service/auth_services/auth_service.dart';

class AuthWithFirebase implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // instance of firebase auth

  @override
  Future<UserModel?> signInWithEmailAndPassWord(
      {required String email,
      required String password,
      String? userName = 'nguyen duc',
      String? phoneNum = '0123456'}) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('---------------${credential.user?.uid}-----------------');

      return credential.user != null
          ? UserModel(
              id: credential.user!.uid,
              email: credential.user!.email!,
              phoneNum: phoneNum,
              userName: userName,
              password: password,
            )
          : null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserModel?> signUpWithEmailAndPassWord(
      {required String email, required String password, String? userName, String? phoneNum}) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set({
        'email': email,
        'password': password,
        'userName': userName,
        'phoneNum': phoneNum,
      });
      return credential.user != null
          ? UserModel(
              id: credential.user!.uid,
              email: credential.user!.email!,
              phoneNum: phoneNum,
              userName: userName,
              password: password,
            )
          : null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }
}
