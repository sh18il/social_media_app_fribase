import 'package:cloud_firestore/cloud_firestore.dart';

class LikeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> likePost(String postId, String userId) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    DocumentReference userLikeRef = postRef.collection('likes').doc(userId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot userLikeSnapshot = await transaction.get(userLikeRef);

      if (!userLikeSnapshot.exists) {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          throw Exception("Post does not exist!");
        }

        Map<String, dynamic>? postData = postSnapshot.data() as Map<String, dynamic>?;
        int currentLikeCount = postData?['likes'] ?? 0;

        int newLikeCount = currentLikeCount + 1;

        transaction.update(postRef, {'likes': newLikeCount});
        transaction.set(userLikeRef, {'likedAt': FieldValue.serverTimestamp()});
      }
    });
  }

  Future<void> unlikePost(String postId, String userId) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);
    DocumentReference userLikeRef = postRef.collection('likes').doc(userId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot userLikeSnapshot = await transaction.get(userLikeRef);

      if (userLikeSnapshot.exists) {
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          throw Exception("Post does not exist!");
        }

        Map<String, dynamic>? postData = postSnapshot.data() as Map<String, dynamic>?;
        int currentLikeCount = postData?['likes'] ?? 0;

        if (currentLikeCount > 0) {
          int newLikeCount = currentLikeCount - 1;

          transaction.update(postRef, {'likes': newLikeCount});
          transaction.delete(userLikeRef);
        }
      }
    });
  }

  Future<bool> isPostLiked(String postId, String userId) async {
    DocumentReference userLikeRef = _firestore.collection('posts').doc(postId).collection('likes').doc(userId);
    DocumentSnapshot userLikeSnapshot = await userLikeRef.get();
    return userLikeSnapshot.exists;
  }

  Future<int> getLikeCount(String postId) async {
    DocumentSnapshot postSnapshot = await _firestore.collection('posts').doc(postId).get();
    if (postSnapshot.exists) {
      Map<String, dynamic>? postData = postSnapshot.data() as Map<String, dynamic>?;
      return postData?['likes'] ?? 0;
    } else {
      return 0;
    }
  }
}
