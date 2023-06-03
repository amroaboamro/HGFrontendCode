// //import 'package:chat_app/Authenticate/LoginScree.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// //import 'package:flutter_application_2/LOG.dart';
// import 'package:firebase_admin/firebase_admin.dart';
// import 'package:head_gasket/login.dart';
//
//
// Future<User?> createAccount(String name, String email, String password) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   try {
//     User? user = (await _auth.createUserWithEmailAndPassword(
//             email: email, password: password))
//         .user;
//
//     if (user != null) {
//       print("Account created Successfull");
//
//       user.updateProfile(displayName: name);
//
//       await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
//         "name": name,
//         "email": email,
//         "status": "Unavalible",
//         "uid": _auth.currentUser!.uid,
//       });
//
//       return user;
//     } else {
//       print("account failed");
//       return user;
//     }
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }
//
// Future<User?> logIn(String email, String password) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   // FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   try {
//     User? user = (await _auth.signInWithEmailAndPassword(
//             email: email, password: password))
//         .user;
//   print('here');
//     if (user != null) {
//       print("log Successfull");
//       return user;
//     } else {
//       print("log failed");
//       return user;
//     }
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }
//
// Future signOut(BuildContext context) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//
//   try {
//     await _auth.signOut().then((value) {
//       Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
//     });
//   } catch (e) {
//     print("error");
//   }
//
// }
//
//
// Future changeData(BuildContext context, String name) async {
//   FirebaseFirestore _fireStore = FirebaseFirestore.instance;
//
//  FirebaseAuth _auth = FirebaseAuth.instance;
//   try {
//    await _fireStore.collection('users').doc(_auth.currentUser?.uid).update({
//         "name": name,
//         "status": "Unavalible",
//         "uid": _auth.currentUser!.uid,
//       });
//   } catch (e) {
//     print("error");
//   }
//
// }
//
//
// Future<void> changePassword(String newPassword) async {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   User? user = auth.currentUser;
//
//   try {
//     if(user != null) {
//     await user.updatePassword(newPassword);
//     print('Password updated successfully');
//     }
//   } catch (e) {
//     print('Error updating password: $e');
//   }
// }
//
//
// Future<void> updateFirebasePassword(String email, String newPassword) async {
//   try {
//     // Get the Firebase user with the given email
//     print(email);
//     final userQuery = await FirebaseFirestore.instance
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .limit(1)
//         .get();
//
//     if (userQuery.docs.isNotEmpty) {
//       final userDoc = userQuery.docs.first;
//       final userId = userDoc.id;
// print(userId);
// print(newPassword);
//       // Update the user's password
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .update({'password': newPassword});
//
//          final updatedUserDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//       print('Updated user document: ${updatedUserDoc.data()}');
//
//       print('Password updated successfully');
//     } else {
//       // User not found
//       print('User not found');
//     }
//   } catch (e) {
//     // Handle errors
//     print('Error updating password: $e');
//   }
// }
//
//
//
//
