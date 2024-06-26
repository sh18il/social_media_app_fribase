import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:flutter/material.dart';

class FollowServiceController extends ChangeNotifier {
  FollowService service = FollowService();
  List<UserModel> followers = [];

  Future<List<UserModel>> userFollowersGeting(String id) async {
    try {
      followers = await service.getUserFollowers(id);
    } catch (e) {
      print("Error fetching followers: $e");
      followers = [];
    }

    notifyListeners();
    return followers;
  }

   followUserCount(String followUserId) async {
    await service.followUser(followUserId);
    notifyListeners();
  }

  unfollowCount(String unfollowUserId) async {
    await service.unfollowUser(unfollowUserId);
    notifyListeners();
  }

  Future<bool> isFollowing(String userId) async {
    notifyListeners();

    return await service.isFollowing(userId);
  }
 

  Future<UserModel?> userDataGeting(BuildContext context, String userId) async {
    return await service.getUserData(context, userId);
  }
}
