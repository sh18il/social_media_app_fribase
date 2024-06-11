import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:connecthub_social/service/user_service.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  UserService service = UserService();

  ImagePostService getPostService = ImagePostService();
  Stream<List<UserModel>> getUsers() {
    return service.getUser();
  }

  Stream<QuerySnapshot<ImagePostModel>> fetchPostUser(
      ImagePostModel model, String currentUserId) {
    return getPostService.getPostUser(model, currentUserId);
  }
}
