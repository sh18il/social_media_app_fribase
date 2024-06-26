import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/controller/home_page_controller.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/view/chat_user_page.dart';
import 'package:connecthub_social/view/comment_page.dart';
import 'package:connecthub_social/view/profile.dart';
import 'package:connecthub_social/view/user_profile_page.dart';
import 'package:connecthub_social/widgets/shimmer_effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    log("homeScreen");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<HomeController>(context, listen: false);
    final currentUserid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(221, 47, 46, 46),
        appBar: AppBar(
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromARGB(221, 47, 46, 46),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatUserPage(),
                  ));
                },
                icon: const Icon(
                  Icons.chat_outlined,
                  color: Colors.white60,
                ))
          ],
          leading: const Image(
              fit: BoxFit.fill,
              image: AssetImage(
                  "assets/images/it-s-social-media-app-name-is-connect-hub-logo-3d--JM0aIQQSSvWkgMvE_dmyWw-EVwOSYhYQiOQxM4Ubzil_A-removebg-preview.png")),
          title: const Text(
            "CONNECT_HUB",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/red-black-papercut-.jpg"))),
          child: StreamBuilder(
            stream: provider.getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return shimmerWidget(height: height, width: width);

                //  const Center(
                //   child: CircularProgressIndicator(),
                // );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                List<QueryDocumentSnapshot<ImagePostModel>> postRef =
                    snapshot.data?.docs ?? [];
                if (postRef.isEmpty) {
                  return const Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: postRef.length,
                  itemBuilder: (context, index) {
                    final data = postRef[index].data();
                    final postId = postRef[index].id;

                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: () {
                                    if (currentUserid == data.uid) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ProfilePage(),
                                      ));
                                    } else {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => UserProfilePage(
                                            userId: data?.uid ?? ""),
                                      ));
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            getImageProvider(data.userImage),
                                      ),
                                      const Gap(20),
                                      Text(data.username ?? 'No name'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width,
                                height: height * 0.55,
                                child: Image(
                                  image: NetworkImage(data.image.toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                children: [
                                  const Gap(5),
                                  Text(
                                    data.description.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Consumer<HomeController>(
                                    builder: (context, homeController, _) {
                                      final isLiked =
                                          homeController.isLiked(postId);

                                      final likeCount =
                                          homeController.likeCount(postId);
                                      return Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              homeController.toggleLike(postId);
                                            },
                                            icon: Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                          ),
                                          Text('$likeCount likes'),
                                        ],
                                      );
                                    },
                                  ),
                                  const Gap(20),
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        elevation: 5,
                                        context: context,
                                        builder: (context) {
                                          return CommentPage(postId: postId);
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                        Icons.insert_comment_outlined),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.label_important_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
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
