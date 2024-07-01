// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connecthub_social/model/chatmodel.dart';

// class ChatService {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   CollectionReference<MessageModel> getChatMessagesRef(String chatId) {
//     return firestore
//         .collection("chats")
//         .doc(chatId)
//         .collection("messages")
//         .withConverter<MessageModel>(
//           fromFirestore: (snapshot, _) =>
//               MessageModel.fromDoc(snapshot.data()!),
//           toFirestore: (message, _) => message.toDoc(),
//         );
//   }

//   Future<void> sendUserMessage(String chatId, MessageModel model) async {
//     CollectionReference<MessageModel> messagesRef = getChatMessagesRef(chatId);
//     await messagesRef.add(model);
//   }
//   // Stream<List<QueryDocumentSnapshot>> getChats(String currentUserId) {
//   //   return firestore
//   //       .collection('chats')
//   //       .where('users', arrayContains: currentUserId)
//   //       .snapshots()
//   //       .map((snapshot) => snapshot.docs);
//   // }
// }
