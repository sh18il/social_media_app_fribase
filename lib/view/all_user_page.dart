import 'package:connecthub_social/controller/follow_service_controller.dart';
import 'package:connecthub_social/controller/user_controller.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/service/user_service.dart';
import 'package:connecthub_social/view/user_profile_page.dart';
import 'package:connecthub_social/widgets/shimmer_effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AllUserPage extends StatelessWidget {
  const AllUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser?.uid ?? "";
    FollowService followService = FollowService();
    final provider =
        Provider.of<FollowServiceController>(context, listen: false);
    final pro = Provider.of<UserController>(context, listen: false);
    return Scaffold(
      // backgroundColor: const Color.fromARGB(221, 47, 46, 46),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/red-black-papercut-.jpg"))),
        child: StreamBuilder(
          stream: pro.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return shimmerWidget(height: 5, width: 200);
            } else if (snapshot.hasError) {
              return const Center(
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
                            color: const Color.fromARGB(255, 34, 30, 27)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  maxRadius: 30,
                                  backgroundImage: getImageProvider(data.image),
                                ),
                                const Gap(40),
                                Text(
                                  data.username.toString(),
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
                            FutureBuilder<bool>(
                              future:
                                  //...........................................
                                  followService
                                      .isFollowing(data.uid.toString()),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return LoadingAnimationWidget.waveDots(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 50,
                                  );
                                }
                                bool isFollowing = snapshot.data!;
                                return ElevatedButton(
                                  onPressed: () async {
                                    if (isFollowing) {
                                      await provider
                                          .unfollowCount(data.uid.toString());
                                    } else {
                                      await provider
                                          .followUserCount(data.uid.toString());
                                    }
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
