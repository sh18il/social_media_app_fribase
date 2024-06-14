import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/controller/comment_controller.dart';
import 'package:connecthub_social/model/comment_model.dart';

import 'package:connecthub_social/service/follow_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatelessWidget {
  String postId;
  CommentPage({super.key, required this.postId});
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController commetCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommentController>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: provider.getComments(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Something went wrong',
                style: TextStyle(color: Colors.white),
              ));
            } else if (snapshot.data?.isNotEmpty != snapshot.hasData) {
              return Center(
                child: Text(
                  "No commets",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: getImageProvider(data.image),
                              ),
                              Gap(10),
                              Column(
                                children: [
                                  Text(
                                    data.username,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data.commentText.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            formatTimestamp(data.timestamp),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
      bottomSheet: TextFormField(
        controller: commetCtrl,
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  addComment(context);
                },
                icon: Icon(Icons.send)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  addComment(BuildContext context) async {
    final provider = Provider.of<CommentController>(context, listen: false);
    final username = await FollowService().getUserData(context, currentUser);
    CommentModel ctModel = CommentModel(
        postId: postId,
        userId: currentUser,
        commentText: commetCtrl.text,
        timestamp: Timestamp.now(),
        username: username?.username ?? "",
        image: username?.image ?? "");
    commetCtrl.clear();
    await provider.addComment(ctModel);
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MM-dd – kk:mm').format(dateTime);
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
