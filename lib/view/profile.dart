import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/controller/follow_service_controller.dart';
import 'package:connecthub_social/controller/image_controller.dart';
import 'package:connecthub_social/controller/user_controller.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/model/image_post_model.dart';

import 'package:connecthub_social/view/edit_profile_page.dart';
import 'package:connecthub_social/view/follow_users_page.dart';
import 'package:connecthub_social/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final provider =
        Provider.of<FollowServiceController>(context, listen: false);
    final pro = Provider.of<ImagesProvider>(context, listen: false);
    final postFetch = Provider.of<UserController>(context, listen: false);
    return FutureBuilder(
        future: provider.userDataGeting(context, userid),
        builder: (context, snapshot) {
          UserModel? user = snapshot.data;
          return Scaffold(
            backgroundColor: const Color.fromARGB(221, 47, 46, 46),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(221, 47, 46, 46),
              leading: const Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      "assets/images/it-s-social-media-app-name-is-connect-hub-logo-3d--JM0aIQQSSvWkgMvE_dmyWw-EVwOSYhYQiOQxM4Ubzil_A-removebg-preview.png")),
              title: Text(
                user?.username.toString().toUpperCase() ?? "",
                style: const TextStyle(
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
                    icon: const Icon(Icons.logout_sharp)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(1),
              child: FutureBuilder<UserModel?>(
                  future: provider.userDataGeting(context, userid ?? "no"),
                  builder: (context, snapshot) {
                    UserModel? user = snapshot.data;
                    return Container(
                      child: Column(
                        children: [
                          const Gap(20),
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
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Text(
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
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Text(
                                            "FOLLOWING",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const Gap(25),
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
                                        child: const Center(
                                            child: Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                    const Gap(40)
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot<ImagePostModel>>(
                              stream: postFetch.fetchPostUser(
                                  ImagePostModel(uid: user?.uid),
                                  user?.uid ?? ""),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingAnimationWidget.waveDots(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 50,
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
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
                                      const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: PopupMenuButton(
                                            color: const Color.fromARGB(
                                                255, 29, 28, 28),
                                            onSelected: (value) {
                                              if (value == "delete") {
                                                pro.deletePostImage(
                                                    post.image.toString(),
                                                    context);
                                                pro.deletePostDesCription(id);
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
      return const AssetImage('assets/images/1077114.png');
    }
  }
}
