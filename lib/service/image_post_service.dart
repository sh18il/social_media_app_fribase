import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecthub_social/model/image_post_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImagePostService {
  String imageName = DateTime.now().microsecondsSinceEpoch.toString();
  String url = "";
  Reference firebaseStorege = FirebaseStorage.instance.ref();

  String collectionRef = "imgDescription";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<ImagePostModel> postImgRef =
      firestore.collection(collectionRef).withConverter<ImagePostModel>(
            fromFirestore: (snapshot, options) =>
                ImagePostModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.tojson(),
          );

  Future<void> addImage(File image, BuildContext context) async {
    Reference imageFlder = firebaseStorege.child("images");
    Reference uploadedImage = imageFlder.child("$imageName.jpg");
    try {
      await uploadedImage.putFile(image);
      url = await uploadedImage.getDownloadURL();
    } catch (e) {
      _showErrorMessage(context, 'Failed to upload image: ${e.toString()}');
    }
  }

  Future <String?> updateImage(
      String imageUrl, File updateImage, BuildContext context) async {
    try {
      Reference editImageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await editImageRef.putFile(updateImage);
      String newUrl = await editImageRef.getDownloadURL();
      return newUrl;
    } catch (e) {
      _showErrorMessage(context, 'Failed to update image: ${e.toString()}');
      return null;
    }
  }

  Future<void> deleteImage(String imageurl, BuildContext context) async {
    try {
      Reference delete = FirebaseStorage.instance.refFromURL(imageurl);
      await delete.delete();
    } catch (e) {
      _showErrorMessage(context, 'Failed to delete image: ${e.toString()}');
    }
  }

  Future addPost(ImagePostModel model) async {
    await postImgRef.add(model);
  }

  Stream<QuerySnapshot<ImagePostModel>> getPost() {
    return postImgRef.snapshots();
  }

  Future deletePost(String id) async {
    await postImgRef.doc(id).delete();
  }

  Stream<QuerySnapshot<ImagePostModel>> getPostUser(
      ImagePostModel model, String currentUserId) {
    try {
      if (model.uid == currentUserId) {
        return postImgRef
            .where('uid', isEqualTo: currentUserId)
            .withConverter<ImagePostModel>(
              fromFirestore: (snapshot, _) =>
                  ImagePostModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.tojson(),
            )
            .snapshots();
      } else {
        return Stream<QuerySnapshot<ImagePostModel>>.empty();
      }
    } on FirebaseException catch (e) {
      return throw Exception(e);
      //  ShowSnackBar(context, "error$e")
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User posts').doc(postId);
    if (isLiked) {
      await postRef.update({
        'Likes':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.email])
      });
    } else {
      await postRef.update({
        'Likes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.email]),
      });
    }
  }
}
