import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userId;
  final String postId;
  final String commentText;
  final Timestamp timestamp;
  final String image;
  final String username;

  CommentModel( {
   required  this.image,required this.username,
    required this.userId,
    required this.postId,
    required this.commentText,
    required this.timestamp,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userId: json['userId'],
      postId: json['postId'],
      commentText: json['commentText'],
      timestamp: json['timestamp'],
      image: json['image'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
      'commentText': commentText,
      'timestamp': timestamp,
      'username': username,
      'image': image,
    };
  }
}
