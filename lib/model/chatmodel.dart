// import 'package:cloud_firestore/cloud_firestore.dart';

// class MessageModel {
//   final String text;
//   final String sender;
//   final String uid;
//   final Timestamp timestamp;

//   MessageModel({
//     required this.text,
//     required this.sender,
//     required this.uid,
//     required this.timestamp,
//   });

//   factory MessageModel.fromDoc(Map<String, dynamic> data) {
//     return MessageModel(
//       text: data['text'] ?? '',
//       sender: data['sender'] ?? '',
//       uid: data['uid'] ?? '',
//       timestamp: data['timestamp'] ?? Timestamp.now(),
//     );
//   }

//   Map<String, dynamic> toDoc() {
//     return {
//       'text': text,
//       'sender': sender,
//       'uid': uid,
//       'timestamp': timestamp,
//     };
//   }
// }
