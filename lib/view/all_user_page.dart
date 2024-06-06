import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/service/user_service.dart';
import 'package:connecthub_social/view/user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AllUserPage extends StatelessWidget {
  const AllUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser!.uid;
    FollowService followService = FollowService();
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 47, 46, 46),
      body: StreamBuilder(
        stream: UserService().getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("error code"),
            );
          } else {
            List<UserModel> users = (snapshot.data as List<UserModel>)
                .where((user) => user.uid != currentuser)
                .toList();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final data = users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            UserProfilePage(userId: data.uid!),
                      ));
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 34, 30, 27)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                maxRadius: 30,
                                backgroundImage:
                                    NetworkImage(data.image.toString()),
                              ),
                              Gap(40),
                              Text(
                                data.username.toString(),
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                            ],
                          ),
                          FutureBuilder<bool>(
                            future:
                                followService.isFollowing(data.uid.toString()),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              bool isFollowing = snapshot.data!;
                              return ElevatedButton(
                                onPressed: () async {
                                  if (isFollowing) {
                                    await followService
                                        .unfollowUser(data.uid.toString());
                                  } else {
                                    await followService
                                        .followUser(data.uid.toString());
                                  }
                                  // Refresh the state to update the button text
                                  (context as Element).reassemble();
                                },
                                child: Text(
                                  isFollowing ? 'Unfollow ' : 'Follow',
                                  style: TextStyle(
                                      color: isFollowing
                                          ? Colors.red
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
