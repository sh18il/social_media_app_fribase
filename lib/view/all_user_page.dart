import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/service/user_service.dart';
import 'package:connecthub_social/view/user_profile_page.dart';
import 'package:flutter/material.dart';

class AllUserPage extends StatelessWidget {
  const AllUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    FollowService followService = FollowService();
    return Scaffold(
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlueAccent),
                      child: ListTile(
                        hoverColor: const Color.fromARGB(255, 158, 157, 153),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data.image.toString()),
                        ),
                        trailing: FutureBuilder<bool>(
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
                              child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                            );
                          },
                        ),
                        title: Text(data.username.toString()),
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
