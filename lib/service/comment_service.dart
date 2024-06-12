// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connecthub_social/model/auth_model.dart';
// import 'package:connecthub_social/model/comment_model.dart';

// class CommentService {
//   CollectionReference fireStore =
//       FirebaseFirestore.instance.collection("commets");

//  Future<void> addComment(CommentModel comment) async {
//     await fireStore..add(comment.toJson());
//   }

// // Stream<List<CommentModel>> getComment() {
// //     return fireStore.snapshots().map((snapshot) => snapshot.docs
// //         .map((doc) => CommentModel.fromJson(doc.data() as Map<String, dynamic>))
// //         .toList().where(UserModel.postid, isEqualTo: postId)
// //       .orderBy('timestamp', descending: true));
// //   }
//  Stream<List<CommentModel>> getComments(String postId) {
//     return fireStore

//         .where('postId', isEqualTo: postId)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => CommentModel.fromJson(doc.data() as Map<String, dynamic>))
//             .toList());
//   }

//   // Stream<QuerySnapshot> getComment(String postId) {
//   //   return fireStore
//   //       .where('postId', isEqualTo: postId)
//   //       .orderBy('timestamp', descending: true)
//   //       .snapshots();
//   // }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/comment_model.dart';

class CommentService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<List<CommentModel>> getComments(String postId) {
    return fireStore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        // .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                CommentModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addComment(CommentModel comment) async {
    await fireStore.collection('comments').add(comment.toJson());
  }
}
