import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../init.dart';
import 'package:fire_guard/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // instance of firebase auth

  Future<User?> signUpWithEmailAndPassWord(
      {required String email,
      required String password,
      String? userName = 'nguyen duc',
      String? phoneNum = '0123456'}

      ) async {
    try {
      print('email: $email, password: $password, userName: $userName, phoneNum: $phoneNum');
      
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set({
        'email': email,
        'password': password,
        'userName': userName,
        'phoneNum': phoneNum,
      });

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassWord({required String email, required String password}) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('---------------${credential.user?.uid}-----------------');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
      return null;
    }
  }

  Future<void> getDataAllFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      documents.forEach((document) {
        print('User data: ${document.data()}');
      });
    } catch (e) {
      print('Error getting data from Firestore: $e');
    }
  }

  Future<void> getDataById(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(documentId).get();

      if (documentSnapshot.exists) {
        UserModel user = UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
        print('----------${user}');
      } else {
        /**/
        print('Document with ID $documentId does not exist.');
      }
    } catch (e) {
      print('Error getting data from Firestore: $e');
    }
  }

  Future<UserModel> getDataCurrentUser() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid; // Lấy userID của người dùng đã đăng nhập
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (documentSnapshot.exists) {
        UserModel user = UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
        print('----------${user}');
        return user;
      } else {
        /**/
        print('Document with ID $userId does not exist.');
      }
    } catch (e) {
      print('Error getting data from Firestore: $e');
    }
    return UserModel();
  }
}
