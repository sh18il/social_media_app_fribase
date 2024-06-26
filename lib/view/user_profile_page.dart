import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/controller/follow_service_controller.dart';
import 'package:connecthub_social/controller/user_controller.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/view/follow_users_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;
  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final followService = FollowService();
    final provider =
        Provider.of<FollowServiceController>(context, listen: false);
    final pro = Provider.of<UserController>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(96, 63, 54, 54),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: 0.9,
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/red-black-papercut-.jpg"))),
          child: FutureBuilder<UserModel?>(
            future: provider.userDataGeting(context, userId),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError) {
                return Center(child: Text("Error: ${userSnapshot.error}"));
              }

              if (!userSnapshot.hasData) {
                return const Center(child: Text("User not found"));
              }

              UserModel user = userSnapshot.data!;

              return Column(
                children: [
                  const Gap(30),
                  Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: Row(
                      children: [
                        Text(
                          user.username.toString().toUpperCase() ??
                              "No Username",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
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
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Text(
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
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Text(
                              "Following",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Consumer<FollowServiceController>(builder: (context, pro, _) {
                    return FutureBuilder<bool>(
                      future: followService.isFollowing(userId),
                      builder: (context, followSnapshot) {
                        if (followSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (followSnapshot.hasError) {
                          return Text("Error: ${followSnapshot.error}");
                        }

                        bool isFollowing = followSnapshot.data ?? false;

                        return ElevatedButton(
                          onPressed: () async {
                            if (isFollowing) {
                              await pro.unfollowCount(userId);
                            } else {
                              await pro.followUserCount(userId);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                isFollowing ? Colors.red : Colors.blue,
                            elevation: 7,
                            fixedSize: Size.fromWidth(width),
                          ),
                          child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                        );
                      },
                    );
                  }),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<ImagePostModel>>(
                      stream: pro.fetchPostUser(
                          ImagePostModel(uid: user.uid), user.uid ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No posts found.'));
                        }

                        final posts = snapshot.data!.docs
                            .map((doc) => doc.data())
                            .toList();
                        List<QueryDocumentSnapshot<ImagePostModel>> postRef =
                            snapshot.data?.docs ?? [];

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                SizedBox(
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
      ),
    );
  }

  ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/images/1077114.png');
    }
  }
}
