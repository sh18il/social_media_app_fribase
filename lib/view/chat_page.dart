// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class ChatScreen extends StatefulWidget {
// //   @override
// //   _ChatScreenState createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends State<ChatScreen> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   late User _user;
// //   final TextEditingController _messageController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _user = _auth.currentUser!;
// //   }

// //   void _sendMessage() {
// //     if (_messageController.text.isNotEmpty) {
// //       _firestore.collection('messages').add({
// //         'text': _messageController.text,
// //         'sender': _user.email,
// //         'timestamp': FieldValue.serverTimestamp(),
// //       });
// //       _messageController.clear();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Chat'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.logout),
// //             onPressed: () async {
// //               await _auth.signOut();
// //               Navigator.pop(context);
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: StreamBuilder<QuerySnapshot>(
// //               stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) {
// //                   return Center(child: CircularProgressIndicator());
// //                 }
// //                 final messages = snapshot.data!.docs;
// //                 List<Widget> messageWidgets = [];
// //                 for (var message in messages) {
// //                   final messageText = message['text'];
// //                   final messageSender = message['sender'];
// //                   final messageWidget = ListTile(
// //                     title: Text(messageSender),
// //                     subtitle: Text(messageText),
// //                   );
// //                   messageWidgets.add(messageWidget);
// //                 }
// //                 return ListView(
// //                   children: messageWidgets,
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _messageController,
// //                     decoration: InputDecoration(hintText: 'Enter your message...'),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send),
// //                   onPressed: _sendMessage,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connecthub_social/service/follow_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final String name;

//   ChatScreen({required this.chatId, required this.name});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late User _user;
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _user = _auth.currentUser!;
//   }
//   final ss = FollowService();
//   final currentuser = FirebaseAuth.instance.currentUser?.uid ?? "";
//   void _sendMessage() async {

//     final username = await ss.getUserData(context, currentuser);
//     if (_messageController.text.isNotEmpty) {
//       _firestore
//           .collection('chats')
//           .doc(widget.chatId)
//           .collection('messages')
//           .add({
//         'text': _messageController.text,
//         'sender': username?.username ?? "",
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.name}'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//               opacity: 0.3,
//               fit: BoxFit.fill,
//               image: AssetImage("assets/images/red-black-papercut-.jpg")),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(

//                 stream:

//                  _firestore
//                     .collection('chats')
//                     .doc(widget.chatId)
//                     .collection('messages')
//                     .orderBy('timestamp')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   final messages = snapshot.data!.docs;
//                   List<Widget> messageWidgets = [];
//                   for (var message in messages) {

//                     final messageText = message['text'];
//                     final messageSender = message['sender'];
//                     final messageWidget = Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 160,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.elliptical(40, 60)),
//                               color: Colors.amber,
//                             ),
//                             child: Column(
//                               children: [
//                                 Text(messageSender),
//                                 Text(
//                                   messageText,
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       letterSpacing:
//                                           BorderSide.strokeAlignOutside),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                     messageWidgets.add(messageWidget);
//                   }
//                   return ListView(
//                     children: messageWidgets,
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       decoration:
//                           InputDecoration(hintText: 'Enter your message...'),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: _sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/view/user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String name;
  final String uId;

  const ChatScreen(
      {super.key, required this.chatId, required this.name, required this.uId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: unused_field
  late User _user;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  final ss = FollowService();
  final currentuser = FirebaseAuth.instance.currentUser?.uid ?? "";

  void _sendMessage() async {
    final userData = await ss.getUserData(context, currentuser);
    if (_messageController.text.isNotEmpty) {
      _firestore
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': _messageController.text,
        'sender': userData?.username ?? "",
        'uid': currentuser,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfilePage(userId: widget.uId),
              ));
            },
            child: Text('Chat with ${widget.name}')),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              opacity: 0.3,
              fit: BoxFit.fill,
              image: AssetImage("assets/images/red-black-papercut-.jpg")),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!.docs;
                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageSender = message['sender'];
                    final messageUid = message['uid'];
                    final isCurrentUser = messageUid == currentuser;

                    final messageWidget = Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: isCurrentUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? const Color.fromARGB(255, 123, 191, 246)
                                  : const Color.fromARGB(255, 237, 236, 236),
                              borderRadius: isCurrentUser
                                  ? const BorderRadius.only(
                                      topRight: Radius.elliptical(40, 60),
                                      bottomLeft: Radius.circular(20))
                                  : const BorderRadius.only(
                                      topLeft: Radius.elliptical(40, 70),
                                      bottomRight: Radius.circular(20)),
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCurrentUser ? "Me" : messageSender,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  messageText,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    children: messageWidgets,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          hintText: 'Enter your message...'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
