import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/widgets/massege.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// class FirebaseAuthService {
//   FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> singupWithEmailAndPassword(BuildContext context,
//       String username, String email, String password) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       await sendEmailVerification(context);
//       return credential.user;
//     } on FirebaseAuthException catch (e) {
//       ShowSnackBar(context, e.message.toString());
//       return null;
//     }
//   }

//   Future<void> sendEmailVerification(BuildContext context) async {
//     try {
//       _auth.currentUser!.sendEmailVerification();
//       ShowSnackBar(context, "email Verification sent");
//     } on FirebaseAuthException catch (e) {
//       ShowSnackBar(context, e.message!);
//     }
//   }

//   Future<User?> singinWithEmailAndPassword(
//       BuildContext context, String email, String password) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       if (_auth.currentUser!.emailVerified) {
//         await sendEmailVerification(context);
//       }
//       return credential.user;
//     } on FirebaseAuthException catch (e) {
//       ShowSnackBar(context, e.message.toString());
//       return null;
//     }
//   }
//   // signInWithGooglr()async{
//   //   final GoogleSignin
//   // }
// }

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> singupWithEmailAndPassword(BuildContext context,
      String username, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = credential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          username: username,
          email: email,
          uid: user.uid,
          password: password,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());

        await sendEmailVerification(context);

        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.message.toString());
      return null;
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      ShowSnackBar(context, "Email verification sent");
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.message!);
    }
  }

  Future<User?> singinWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.message.toString());
      return null;
    }
  }
}

void ShowSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
