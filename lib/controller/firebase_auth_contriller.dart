import 'dart:io';

import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthContriller extends ChangeNotifier {
  TextEditingController passwordCtrl = TextEditingController();
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

  Future signup(BuildContext context, String username, String email,
      String password, String imageUrl) async {
    try {
      await service.signup(context, username, email, password, imageUrl);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.toString());
    }
  }

  Future signin(BuildContext context, String email, String password) async {
    try {
      await service.signin(context, email, password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.message.toString());
    }
    notifyListeners();
  }
}
