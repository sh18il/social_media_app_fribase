import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthContriller extends ChangeNotifier {
  FirebaseAuthService service = FirebaseAuthService();

  Future<void> EditUserProfile(
      BuildContext context, String userName, String id) async {
    try {
      await service.updateUserProfile(context, userName, id);
      notifyListeners();
    } catch (e) {
      ShowSnackBar(context, "edit is error $e");
    }
  }

  Future signupEmailAndPassword(BuildContext context, String username,
      String email, String password, String imageUrl) async {
    try {
      await service.signupWithEmailAndPassword(
          context, username, email, password, imageUrl);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.toString());
    }
  }

//   Future signinEmailAndPassword(
//       BuildContext context, String email, String password) async {
//     try {
//       await service.signinWithEmailAndPassword(context, email, password);
//       notifyListeners();
//     } on FirebaseAuthException catch (e) {
//       ShowSnackBar(context, e.message.toString());
//     }
//     notifyListeners();
//   }
}
