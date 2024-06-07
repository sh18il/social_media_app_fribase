import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:connecthub_social/view/follow_users_page.dart';
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
          future: followService.getUserData(context, userId),
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
                      backgroundImage: getImageProvider(user.image),
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
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserFollowersPage(
                            userId: user.uid,
                          ),
                        ));
                      },
                      child: Column(
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
                Expanded(
                  child: StreamBuilder<QuerySnapshot<ImagePostModel>>(
                    stream: ImagePostService().getPostUser(
                        ImagePostModel(uid: user.uid), user?.uid ?? ""),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No posts found.'));
                      }

                      final posts =
                          snapshot.data!.docs.map((doc) => doc.data()).toList();
                      List<QueryDocumentSnapshot<ImagePostModel>> postRef =
                          snapshot.data?.docs ?? [];

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          // final id = postRef[index].id;
                          return Stack(
                            children: [
                              Container(
                                width: width * 0.5,
                                child: Card(
                                  elevation: 7,
                                  child: Image.network(
                                    post.image.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage('assets/images/1077114.png');
    }
  }
}
