import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/view/chat_page.dart';
import 'package:connecthub_social/widgets/shimmer_effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatUserPage extends StatelessWidget {
  const ChatUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final currentuser = FirebaseAuth.instance.currentUser?.uid ?? "";
    // final provider =
    //     Provider.of<FollowServiceController>(context, listen: false);
    // final pro = Provider.of<UserController>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/red-black-papercut-.jpg"),
              opacity: 0.2),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('chats')
              .where('users', arrayContains: currentuser)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const shimmerWidget(height: 5, width: 200);
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error code"));
            } else {
              List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
              List<Future<Map<String, dynamic>>> chatFutures = [];

              for (var doc in docs) {
                List<String> users = List<String>.from(doc['users']);
                String otherUserId =
                    users.firstWhere((id) => id != currentuser);
                chatFutures.add(firestore
                    .collection('users')
                    .doc(otherUserId)
                    .get()
                    .then((userDoc) async {
                  DocumentSnapshot? messageDoc = await firestore
                      .collection('chats')
                      .doc(doc.id)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .limit(1)
                      .get()
                      .then((query) =>
                          query.docs.isNotEmpty ? query.docs.first : null);

                  Map<String, dynamic>? latestMessage =
                      messageDoc != null && messageDoc.data() != null
                          ? messageDoc.data() as Map<String, dynamic>?
                          : null;

                  return {
                    'user': userDoc.data(),
                    'latestMessage': latestMessage,
                  };
                }));
              }

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.wait(chatFutures),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const shimmerWidget(height: 5, width: 200);
                  } else if (userSnapshot.hasError) {
                    return const Center(child: Text("Error code"));
                  } else {
                    List<Map<String, dynamic>> chatData = userSnapshot.data!;
                    chatData.sort((a, b) {
                      Timestamp aTimestamp =
                          a['latestMessage']?['timestamp'] ?? Timestamp(0, 0);
                      Timestamp bTimestamp =
                          b['latestMessage']?['timestamp'] ?? Timestamp(0, 0);
                      return bTimestamp.compareTo(aTimestamp);
                    });

                    return ListView.builder(
                      itemCount: chatData.length,
                      itemBuilder: (context, index) {
                        final data = chatData[index]['user'];
                        final latestMessage = chatData[index]['latestMessage'];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              String chatId = await getOrCreateChatId(
                                  currentuser, data['uid']);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatId: chatId,
                                  name: data['username'],
                                  uId: data["uid"],
                                ),
                              ));
                            },
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black87.withOpacity(0.9),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        maxRadius: 30,
                                        backgroundImage:
                                            getImageProvider(data['image']),
                                      ),
                                      const Gap(40),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['username'],
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            latestMessage?['text'] ??
                                                "No messages",
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white70),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () async {
                                        String chatId = await getOrCreateChatId(
                                            currentuser, data['uid']);
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            chatId: chatId,
                                            name: data['username'],
                                            uId: data["uid"],
                                          ),
                                        ));
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(70),
                                          color: Colors.green,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            " ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
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

  Future<String> getOrCreateChatId(String user1Id, String user2Id) async {
    final chatsRef = FirebaseFirestore.instance.collection('chats');
    final chatQuery =
        await chatsRef.where('users', arrayContains: user1Id).get();

    for (var doc in chatQuery.docs) {
      final users = List<String>.from(doc['users']);
      if (users.contains(user2Id)) {
        return doc.id;
      }
    }

    final newChatDoc = await chatsRef.add({
      'users': [user1Id, user2Id],
    });

    return newChatDoc.id;
  }
}
