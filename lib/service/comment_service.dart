import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/comment_model.dart';

class CommentService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<List<CommentModel>> getComments(String postId) {
    return fireStore
        .collection('comments')
        .where('postId', isEqualTo: postId)
       
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
