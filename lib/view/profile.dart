import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:connecthub_social/view/edit_profile_page.dart';
import 'package:connecthub_social/view/follow_users_page.dart';
import 'package:connecthub_social/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder(
        future: FollowService().getUserData(context, userid),
        builder: (context, snapshot) {
          UserModel? user = snapshot.data;
          return Scaffold(
            backgroundColor: Color.fromARGB(221, 47, 46, 46),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(221, 47, 46, 46),
              leading: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      "assets/images/it-s-social-media-app-name-is-connect-hub-logo-3d--JM0aIQQSSvWkgMvE_dmyWw-EVwOSYhYQiOQxM4Ubzil_A-removebg-preview.png")),
              title: Text(
                user?.username.toString().toUpperCase() ?? "",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                    },
                    icon: Icon(Icons.logout_sharp)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(1),
              child: FutureBuilder<UserModel?>(
                  future: FollowService().getUserData(context, userid ?? "no"),
                  builder: (context, snapshot) {
                    UserModel? user = snapshot.data;
                    return Container(
                      child: Column(
                        children: [
                          Gap(20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       user?.username.toString().toUpperCase() ??
                          //           "UserName",
                          //       style: TextStyle(
                          //           fontSize: 20,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.white),
                          //     ),
                          //   ],
                          // ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                        maxRadius: 40,
                                        backgroundImage:
                                            getImageProvider(user?.image)),
                                    InkWell(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Text(
                                            user?.followers.toString() ?? "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "FOLLOWERS",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              UserFollowersPage(userId: userid),
                                        ));
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            user?.following.toString() ?? "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "FOLLOWING",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Gap(25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => EditProfilePage(
                                              userModel: UserModel(
                                                  image: user?.image ?? "",
                                                  username:
                                                      user?.username ?? ""),
                                              id: user?.uid ?? ""),
                                        ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey,
                                        ),
                                        width: width * 0.5,
                                        height: height * 0.04,
                                        child: Center(
                                            child: Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                    Gap(40)
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot<ImagePostModel>>(
                              stream: ImagePostService().getPostUser(
                                  ImagePostModel(uid: user?.uid),
                                  user?.uid ?? ""),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Center(
                                      child: Text(
                                    'No posts found.',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 243, 241, 241)),
                                  ));
                                }

                                final posts = snapshot.data!.docs
                                    .map((doc) => doc.data())
                                    .toList();
                                List<QueryDocumentSnapshot<ImagePostModel>>
                                    postRef = snapshot.data?.docs ?? [];

                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 0.95,
                                  ),
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    final post = posts[index];
                                    final id = postRef[index].id;
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
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: PopupMenuButton(
                                            color: const Color.fromARGB(
                                                255, 29, 28, 28),
                                            onSelected: (value) {
                                              if (value == "delete") {
                                                ImagePostService().deleteImage(
                                                    post.image.toString(),
                                                    context);
                                                ImagePostService()
                                                    .deletePost(id);
                                              }
                                            },
                                            itemBuilder: (context) {
                                              return [
                                                const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))
                                              ];
                                            },
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
                      ),
                    );
                  }),
            ),
          );
        });
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
