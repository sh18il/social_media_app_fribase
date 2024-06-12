import 'package:connecthub_social/model/comment_model.dart';
import 'package:connecthub_social/service/comment_service.dart';
import 'package:flutter/material.dart';

class CommentController extends ChangeNotifier {
  CommentService service = CommentService();
  Stream<List<CommentModel>> getComments(String postId) {
    return service.getComments(postId);
  }

  Future<void> addComment(CommentModel comment) async {
    await service.addComment(comment);
  }
}
