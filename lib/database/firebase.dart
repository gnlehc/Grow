// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("users");

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signUp(
    String email,
    String password,
    String username,
    String telephoneNum,
    String fullName,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('User is null.');
      }

      String uid = credential.user!.uid;

      DocumentReference userRef = _userCollection.doc(uid);
      final userData = <String, dynamic>{
        'fullName': fullName,
        'telephoneNum': telephoneNum,
        'username': username,
        'email': email,
        'balance': 0,
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
      throw Exception('Error signing out: $e');
    }
  }

  List userList = [];
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  Future getData() async {
    try {
      await userCollection.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          userList.add(result.data());
        }
      });

      return userList;
    } catch (e) {
      return e;
    }
  }

  Future<int> getBalance(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _userCollection.doc(userId).get()
              as DocumentSnapshot<Map<String, dynamic>>;

      final userData = userSnapshot.data();
      if (userData != null && userData.containsKey('balance')) {
        final double balance = userData['balance'] ?? 0.0;
        return balance.toInt();
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<void> topUpBalance(String userId, int amount) async {
    try {
      // Get the user document
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _userCollection.doc(userId).get()
              as DocumentSnapshot<Map<String, dynamic>>;

      if (userSnapshot.exists) {
        dynamic currentBalance = userSnapshot.data()?['balance'] ?? 0;

        if (currentBalance is! int) {
          currentBalance = (currentBalance ?? 0).toInt();
        }

        int newBalance = currentBalance + amount;

        await _userCollection.doc(userId).update({'balance': newBalance});
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      throw Exception('Error topping up balance: $e');
    }
  }

  Future<void> updateTransaction({
    required String userId,
    required String transactionId,
    required String category,
    required int amount,
  }) async {
    try {
      await _userCollection
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .update({
        'category': category,
        'amount': amount,
      });
    } catch (e) {
      throw Exception('Error updating transaction: $e');
    }
  }

  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {
    try {
      await _userCollection
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (e) {
      throw Exception('Error deleting transaction: $e');
    }
  }
}
