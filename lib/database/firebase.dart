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
      print('Error signing out: $e');
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
        return balance.toInt(); // Convert double balance to int
      } else {
        return 0; // Return 0 if balance is not found or null
      }
    } catch (e) {
      // Proper error handling
      print('Error getting balance: $e');
      return 0; // Return default value in case of error
    }
  }

  Future<void> topUpBalance(String userId, int amount) async {
    try {
      // Get the user document
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _userCollection.doc(userId).get()
              as DocumentSnapshot<Map<String, dynamic>>;

      // Check if the user document exists
      if (userSnapshot.exists) {
        // Get the current balance
        dynamic currentBalance = userSnapshot.data()?['balance'] ?? 0;

        // Convert current balance to int if it's not already
        if (currentBalance is! int) {
          currentBalance = (currentBalance ?? 0).toInt();
        }

        // Calculate new balance after top-up
        int newBalance = currentBalance + amount;

        // Update the user document with the new balance
        await _userCollection.doc(userId).update({'balance': newBalance});
      } else {
        throw Exception('User not found.');
      }
    } catch (e) {
      print('Error topping up balance: $e');
      throw Exception('Error topping up balance: $e');
    }
  }
}
