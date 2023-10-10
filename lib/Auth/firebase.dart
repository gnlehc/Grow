// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future<User?> signUp(
    String email,
    String password,
    String username,
    String telephoneNum,
    String fullName,
  ) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user == null) {
        throw Exception('User is null.');
      }
      String uid = credential.user!.uid;

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      final userData = <String, dynamic>{
        'fullName': fullName,
        'telephoneNum': telephoneNum,
        'username': username,
        'email': email,
        'balance': 0,
        'password': password,
      };
      await userRef.set(userData);

      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
