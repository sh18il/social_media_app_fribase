// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connecthub_social/controller/sigin_page.dart';
// import 'package:connecthub_social/model/auth_model.dart';
// import 'package:connecthub_social/widgets/massege.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// // class FirebaseAuthService {
// //   FirebaseAuth _auth = FirebaseAuth.instance;

// //   Future<User?> singupWithEmailAndPassword(BuildContext context,
// //       String username, String email, String password) async {
// //     try {
// //       UserCredential credential = await _auth.createUserWithEmailAndPassword(
// //           email: email, password: password);
// //       await sendEmailVerification(context);
// //       return credential.user;
// //     } on FirebaseAuthException catch (e) {
// //       ShowSnackBar(context, e.message.toString());
// //       return null;
// //     }
// //   }

// //   Future<void> sendEmailVerification(BuildContext context) async {
// //     try {
// //       _auth.currentUser!.sendEmailVerification();
// //       ShowSnackBar(context, "email Verification sent");
// //     } on FirebaseAuthException catch (e) {
// //       ShowSnackBar(context, e.message!);
// //     }
// //   }

// //   Future<User?> singinWithEmailAndPassword(
// //       BuildContext context, String email, String password) async {
// //     try {
// //       UserCredential credential = await _auth.signInWithEmailAndPassword(
// //           email: email, password: password);
// //       if (_auth.currentUser!.emailVerified) {
// //         await sendEmailVerification(context);
// //       }
// //       return credential.user;
// //     } on FirebaseAuthException catch (e) {
// //       ShowSnackBar(context, e.message.toString());
// //       return null;
// //     }
// //   }
// //   // signInWithGooglr()async{
// //   //   final GoogleSignin
// //   // }
// // }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/widgets/massege.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String imageName = DateTime.now().microsecondsSinceEpoch.toString();
  String url = "";
  Reference firebaseStorage = FirebaseStorage.instance.ref();

  String collectionRef = "users";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<UserModel> postImgRef =
      firestore.collection(collectionRef).withConverter<UserModel>(
            fromFirestore: (snapshot, options) =>
                UserModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<void> addImage(File image, BuildContext context) async {
    Reference imageFolder = firebaseStorage.child("images");
    Reference uploadedImage = imageFolder.child("$imageName.jpg");
    try {
      await uploadedImage.putFile(image);
      url = await uploadedImage.getDownloadURL();
    } catch (e) {
      ShowSnackBar(context, 'Failed to upload image: ${e.toString()}');
    }
  }

  Future updateImage(
      String imageUrl, File updateImage, BuildContext context) async {
    try {
      Reference editImageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await editImageRef.putFile(updateImage);
      String newUrl = await editImageRef.getDownloadURL();
      return newUrl;
    } catch (e) {
      ShowSnackBar(context, 'Failed to update image: ${e.toString()}');
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl, BuildContext context) async {
    try {
      Reference delete = FirebaseStorage.instance.refFromURL(imageUrl);
      await delete.delete();
    } catch (e) {
      ShowSnackBar(context, 'Failed to delete image: ${e.toString()}');
    }
  }

  Future<User?> signupWithEmailAndPassword(
      BuildContext context, String username, String email, String password, String imageUrl) async {
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
          image: imageUrl,
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

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

  Future<User?> signinWithEmailAndPassword(
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
