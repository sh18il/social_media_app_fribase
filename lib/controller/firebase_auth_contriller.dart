import 'dart:io';

import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthContriller extends ChangeNotifier {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController userNameCtrl = TextEditingController();

  TextEditingController passwordCtrl = TextEditingController();
  FirebaseAuthService service = FirebaseAuthService();
  File? selectedImage;

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

  Future signinEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await service.signinWithEmailAndPassword(context, email, password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.message.toString());
    }
    notifyListeners();
  }

  void login(BuildContext context) async {
    // final provider =
    //     Provider.of<FirebaseAuthContriller>(context, listen: false);
    // FirebaseAuthService auth = FirebaseAuthService();
    String email = emailCtrl.text;
    String password = passwordCtrl.text;

    User? user = await service.signinWithEmailAndPassword(
      context,
      email,
      password,
    );

    if (user != null) {
      print("user secssus full login");
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BottomNav(),
        ),
        (route) => false,
      );
      clear();
    } else {
      print("some error happend");
    }
  }

  void signUp(BuildContext context) async {
    String username = userNameCtrl.text;
    String email = emailCtrl.text;
    String password = passwordCtrl.text;

    if (selectedImage != null) {
      await service.addImage(selectedImage!, context);
      String imageUrl = service.url;

      User? user = await service.signupWithEmailAndPassword(
          context, username, email, password, imageUrl);

      if (user != null) {
        print("User is successful");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BottomNav(),
        ));
        clear();
      }
    } else {
      ShowSnackBar(context, "Please select an image");
    }
  }

  clear() {
    userNameCtrl.clear();
    emailCtrl.clear();
    passwordCtrl.clear();
  }
}
