import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/service/image_post_service.dart';
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
    final user = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        leading: Image(
            fit: BoxFit.fill,
            image: AssetImage(
                "assets/images/hub-logo-design-template-free-vector-removebg-preview.png")),
        title: Text(
          "CONNECT_HUB",
          style: TextStyle(
              color: Colors.black,
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
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<UserModel?>(
            future: FollowService().getUserData(user),
            builder: (context, snapshot) {
              UserModel? user = snapshot.data;
              return Column(
                children: [
                  Text(
                    user!.username.toString().toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              maxRadius: 40,
                              backgroundImage:
                                  NetworkImage(user.image.toString()),
                            ),
                            Column(
                              children: [
                                Text("FOLLOWERS"),
                                Text(user.followers.toString())
                              ],
                            ),
                            Column(
                              children: [
                                Text("FOLLOWING"),
                                Text(user.following.toString())
                              ],
                            )
                          ],
                        ),
                        Gap(25),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
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
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<ImagePostModel>>(
                      stream: ImagePostService().getPostUser(
                          ImagePostModel(image: "", uid: user.uid), user.uid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No posts found.'));
                        }

                        final posts = snapshot.data!.docs
                            .map((doc) => doc.data())
                            .toList();
                        List<QueryDocumentSnapshot<ImagePostModel>> postRef =
                            snapshot.data?.docs ?? [];

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final id = postRef[index].id;
                            return Card(
                              elevation: 5,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      post.image.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          post.description.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              ImagePostService().deleteImage(
                                                  post.image.toString(),
                                                  context);
                                              ImagePostService().deletePost(id);
                                            },
                                            icon: Icon(Icons.delete)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
