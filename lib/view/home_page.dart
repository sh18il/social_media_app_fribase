import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:connecthub_social/view/add_page.dart';
import 'package:connecthub_social/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    final userr = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(

          // floatingActionButton: FloatingActionButton.small(onPressed: () {
          //   Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => AddPage(),
          //   ));
          // }),
          body:
              // ElevatedButton(
              //     onPressed: () {
              //       FirebaseAuth.instance.signOut();
              //       Navigator.of(context).pushReplacement(MaterialPageRoute(
              //         builder: (context) => LoginPage(),
              //       ));
              //     },
              //     child: Text("log Out")),
              StreamBuilder(
        stream: ImagePostService().getPost(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("error"),
            );
          } else {
            User? user = FirebaseAuth.instance.currentUser;
            List<QueryDocumentSnapshot<ImagePostModel>> postRef =
                snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: postRef.length,
              itemBuilder: (context, index) {
                final id = postRef[index].id;
                final data = postRef[index].data();
                return Container(
                  child: Column(
                    children: [
                      Container(
                          width: width,
                          height: height * 0.8,
                          child: Column(
                            children: [
                              Gap(50),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(),
                                    Text(user!.displayName.toString()),
                                    IconButton(
                                        onPressed: () {
                                          ImagePostService().deleteImage(
                                              data.image.toString(), context);
                                          ImagePostService().deletePost(id);
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                ),
                              ),
                              Container(
                                width: width,
                                height: height * 0.6,
                                child: Image(
                                    image: NetworkImage(data.image.toString())),
                              ),
                              Text(data.description.toString()),
                              
                            ],
                          )),
                    ],
                  ),
                );
              },
            );
          }
        },
      )),
    );
  }
}

// User? user = FirebaseAuth.instance.currentUser;
// if (user != null) {
//   // User is signed in, you can access user data
//   String userName = user.displayName ?? "Unknown";
//   String userEmail = user.email ?? "No Email";
  
//   // Now you can use userName and userEmail in your UI
//   // For example:
//   Text("Welcome, $userName"),
//   Text("Email: $userEmail"),
// } else {
//   // User is not signed in, handle this case accordingly
// }