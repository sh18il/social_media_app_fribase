import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;
  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final followService = FollowService();

    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: FutureBuilder<UserModel?>(
        future: followService.getUserData(userId),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text("Error: ${userSnapshot.error}"));
          }

          if (!userSnapshot.hasData) {
            return Center(child: Text("User not found"));
          }

          UserModel user = userSnapshot.data!;

          return Column(
            children: [
              ListTile(
                title: Text(user.username ?? "No Username"),
                subtitle: Text(user.email ?? "No Email"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text("Followers"),
                      Text(user.followers.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Following"),
                      Text(user.following.toString()),
                    ],
                  ),
                ],
              ),
              FutureBuilder<bool>(
                future: followService.isFollowing(userId),
                builder: (context, followSnapshot) {
                  if (followSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (followSnapshot.hasError) {
                    return Text("Error: ${followSnapshot.error}");
                  }

                  bool isFollowing = followSnapshot.data ?? false;

                  return ElevatedButton(
                    onPressed: () async {
                      if (isFollowing) {
                        await followService.unfollowUser(userId);
                      } else {
                        await followService.followUser(userId);
                      }
                      // Refresh the follow status and user data
                      (context as Element).reassemble();
                    },
                    child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: isFollowing ? Colors.red : Colors.blue,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
