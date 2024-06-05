import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> followUser(String followUserId) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      await _firestore
          .collection('followers')
          .doc(currentUserId)
          .collection('userFollowers')
          .doc(followUserId)
          .set({'followed': true});

      await _firestore.collection('users').doc(followUserId).update({
        'followers': FieldValue.increment(1),
      });

      await _firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.increment(1),
      });
    } catch (e) {}
  }

  Future<void> unfollowUser(String unfollowUserId) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      await _firestore
          .collection('followers')
          .doc(currentUserId)
          .collection('userFollowers')
          .doc(unfollowUserId)
          .delete();

      await _firestore.collection('users').doc(unfollowUserId).update({
        'followers': FieldValue.increment(-1),
      });

      await _firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.increment(-1),
      });
    } catch (e) {}
  }

  Future<bool> isFollowing(String userId) async {
    String currentUserId = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _firestore
        .collection('followers')
        .doc(currentUserId)
        .collection('userFollowers')
        .doc(userId)
        .get();
    return doc.exists;
  }

 

  Future<UserModel?> getUserData(BuildContext context, String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      ShowSnackBar(context, "gett data is error $e");
    }
  }

  void ShowSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
