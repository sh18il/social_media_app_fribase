import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  ImagePostService service = ImagePostService();
  Map<String, bool> _likeStates = {};
  Map<String, int> _likeCounts = {};

  bool isLiked(String postId) => _likeStates[postId] ?? false;
  int likeCount(String postId) => _likeCounts[postId] ?? 0;

  void toggleLike(String postId) {
    _likeStates[postId] = !(_likeStates[postId] ?? false);
    _likeCounts[postId] =
        (_likeCounts[postId] ?? 0) + (_likeStates[postId]! ? 1 : -1);
    notifyListeners();
  }

  Stream<QuerySnapshot<ImagePostModel>> getPosts() {
    return service.getPost();
  }
}
