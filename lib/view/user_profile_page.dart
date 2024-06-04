import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;
  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final followService = FollowService();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(96, 63, 54, 54),
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
                Gap(30),
                Text(
                  user.username.toString().toUpperCase() ?? "No Username",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      maxRadius: 40,
                      backgroundImage: NetworkImage(user.image ?? ""),
                    ),
                    Column(
                      children: [
                        Text(
                          user.followers.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Followers",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          user.following.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Following",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(20),
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
                        elevation: 7,
                        fixedSize: Size.fromWidth(width),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
