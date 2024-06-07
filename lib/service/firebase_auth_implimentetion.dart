import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<void> updateUserProfile(
      BuildContext context, String userName, String id) async {
    try {
      await postImgRef.doc(id).update({"username": userName});
    } catch (e) {
      ShowSnackBar(context, "faildUpdate");
    }
  }

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

  Future<User?> signup(BuildContext context, String username, String email,
      String password, String imageUrl) async {
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

  Future<User?> signin(
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

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        DocumentReference userDoc =
            _firestore.collection('users').doc(user.uid);
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
      
          UserModel newUser = UserModel(
            username: googleUser.displayName,
            email: user.email,
            
            uid: user.uid,
            image:"", 
            followers: 0,
            following: 0,
          );

          await userDoc.set(newUser.toJson());
        }
      }

      return userCredential;
    } catch (e) {
      ShowSnackBar(context, 'Error signing in with Google: $e');
      print('Error signing in with Google: $e');
      return null;
    }
  }
}

void ShowSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
