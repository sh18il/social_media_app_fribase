import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:connecthub_social/service/user_service.dart';
import 'package:connecthub_social/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: Text(user!.displayName.toString()),
        title: Text(user!.email.toString()),
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
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(),
                      Column(
                        children: [Text("FOLLOWERS"), Text("0")],
                      ),
                      Column(
                        children: [Text("FOLLOWING"), Text("0")],
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
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<ImagePostModel>>(
                stream: ImagePostService().getPostUser(
                    ImagePostModel(image: "", uid: user.uid), user.uid),
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

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                       final id = postRef[index].id;
                      return Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                ImagePostService().deleteImage(
                                    post.image.toString(), context);
                                ImagePostService().deletePost(id);
                              },
                              icon: Icon(Icons.delete)),
                          ListTile(
                            title: Text(post.description.toString()),
                            subtitle: Image.network(post.image.toString()),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
