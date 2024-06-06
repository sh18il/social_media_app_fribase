import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/controller/home_page_controller.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/image_post_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(221, 47, 46, 46),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(96, 63, 54, 54),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.chat_outlined))
          ],
          leading: Image(
              fit: BoxFit.fill,
              image: AssetImage(
                  "assets/images/hub-logo-design-template-free-vector-removebg-preview.png")),
          title: Text(
            "CONNECT_HUB",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
        ),
        body: StreamBuilder(
          stream: ImagePostService().getPost(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
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

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          getImageProvider(data.userImage),
                                    ),
                                    Gap(20),
                                    Text(data.username ?? 'No name'),
                                  ],
                                ),
                              ),
                              Container(
                                width: width,
                                height: height * 0.55,
                                child: Image(
                                  image: NetworkImage(data.image.toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                children: [
                                  Gap(5),
                                  Text(
                                    data.description.toString(),
                                    style: TextStyle(
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
                                  Gap(20),
                                  IconButton(
                                    onPressed: () {
                                      
                                      
                                      
                                    },
                                    icon: Icon(Icons.insert_comment_outlined),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.label_important_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
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
      return AssetImage(
          'assets/images/hub-logo-design-template-free-vector-removebg-preview.png');
    }
  }
}
